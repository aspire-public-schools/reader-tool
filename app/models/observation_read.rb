class ObservationRead < ActiveRecord::Base
  attr_accessible :quality_overall, :alignment_overall, :observation_status, :id, :observation_group_id, :employee_id_observer, :employee_id_learner, :correlation, :average_difference, :percent_correct, :reader_id, :created_at, :updated_at, :reader_number, :comments, :flagged
  has_many :domain_scores
  has_many :domains, through: :domain_scores, uniq: true
  has_many :indicator_scores, through: :domain_scores
  has_many :evidence_scores,  through: :indicator_scores
  belongs_to :reader


  STATES = ["1","2","3"]

  STATUS_WORD_MAPPING = {1 => :waiting, 2 => :ready, 3 => :finished}.freeze

  def status
    STATUS_WORD_MAPPING[self.observation_status].to_s
  end

  def reader_number_ordinal
    %w[ 1a 1b 2 ].find_index( reader_number ) + 1
  end

  def self.reader kind
    where( reader_number: kind.to_s )
  end

  def final?
    reader_number == '2'
  end

  def finalize!
    update_attributes(observation_status: 3) # finished
    #open up the 2nd read if one is flagged
  if self.flagged
      read_2 = ObservationRead.where(observation_group_id: self.observation_group_id, reader_number: '2').first
      read_2.update_attributes(observation_status: 2) # ready
    end
  end

  # this gets called from IndicatorScoresController#update
  def update_scores!
    scores = find_section_scores

    if score = scores[0]  # document
      document_quality   = quality_cert( score )
      document_alignment = alignment_cert( score )
    end

    if final? && score = scores[1]  # live
      live_quality   = quality_cert( score )
      live_alignment = alignment_cert( score )
    end

    save!
  end

# Have the drop downs autofill for Quality with: 
# “1” when total count of flags equals or is greater than 8 
# “2” when total count of flags is greater than or equal to 4 and less than or equal to 7
# “3” when total count of flags is less than 4 

  def quality_cert score
    case score.quality_sum.to_f
    when 0..4
      STATES[3] #3
    when 5..7
      STATES[2] # Cert
    else
      STATES[1] # NYC
    end
  end

  def alignment_cert score
    case score.alignment_sum.to_f
    when 0...2
      STATES[3] # Cert w. Dist
    when 2...4
      STATES[2] # Cert
    when 4..7
      STATES[1] # Cond Cert
    else
      STATES[9] # NYC
    end
  end

  #for alignment & quality_overall values, return the stored value if it exists, otherwise calc based on the num # of indicator dings
  def alignment_overall
    current_score = self[:alignment_overall]
    if current_score == "" || current_score == nil
      scores = self.find_scores_by_unique_indicator()
      alignment_sum = scores.values.sum{|x| x.alignment_sum.to_i }
      case alignment_sum
      when 0..4
        return "1"
      when 5..7
        return "2"
      else
        return "3"
      end
    else
      p "Not null: #{current_score}"
      return current_score
    end
  end

  def quality_overall
    current_score = self[:quality_overall]
    if current_score == "" || current_score == nil
      scores = self.find_scores_by_unique_indicator()
      quality_sum = scores.values.sum{|x| x.quality_sum.to_i }
      case quality_sum
      when 0..4
        return "1"
      when 5..7
        return "2"
      else
        return "3"
      end
    else
      return current_score
    end
  end

  def find_scores_by_domain_number
    output = self.class.find_scores_by_domain_number(self.id)
    Hash[ output.map{|x| [ x.number.to_i, x ] } ]
  end

  def find_scores_by_unique_indicator
    output = self.class.find_scores_by_unique_indicator(self.id)
    Hash[ output.map{|x| [ x.number.to_i, x ] } ]
  end

  def find_section_scores
    self.class.find_section_scores self.id
  end


  #####################
  #   class methods
  #####################

  def self.status kind
    where(observation_status: STATUS_WORD_MAPPING.invert[kind.to_sym] )
  end

  def self.last_read
    order('updated_at DESC').first.try(:updated_at)
  end

  def self.find_scores_by_unique_indicator id
    find_by_sql <<-SQL
      SELECT #{id}
        AS id 
        , domains.number
        , COALESCE(quality_sum,0) AS quality_sum
        , COALESCE(alignment_sum,0) AS alignment_sum
      FROM domains
      LEFT JOIN (SELECT obr.id, dom.number, COUNT(DISTINCT inds.indicator_id) AS quality_sum
          FROM observation_reads obr
      LEFT JOIN domain_scores doms
          ON doms.observation_read_id = obr.id
      LEFT JOIN domains dom
          ON doms.domain_id = dom.id
      LEFT JOIN indicator_scores inds
          ON inds.domain_score_id = doms.id
      LEFT JOIN evidence_scores evds
          ON evds.indicator_score_id = inds.id
      WHERE obr.id = #{id}
        AND quality <> 0
      GROUP BY obr.id, dom.number) qual
    ON qual.number = domains.number
   LEFT JOIN (SELECT obr.id, dom.number, COUNT(DISTINCT inds.indicator_id) AS alignment_sum
      FROM observation_reads obr
      LEFT JOIN domain_scores doms
          ON doms.observation_read_id = obr.id
      LEFT JOIN domains dom
          ON doms.domain_id = dom.id
      LEFT JOIN indicator_scores inds
          ON inds.domain_score_id = doms.id
      LEFT JOIN evidence_scores evds
          ON evds.indicator_score_id = inds.id
      WHERE obr.id = #{id}
        AND alignment <> 0
      GROUP BY obr.id, dom.number) ali
    ON ali.number = domains.number
    SQL
  end

  def self.find_scores_by_domain_number id
    find_by_sql <<-SQL
      SELECT obr.id, dom.number,
          AVG(evds.quality::float)   AS quality_average, 
          AVG(evds.alignment::float) AS alignment_average,
          SUM(evds.quality::float)   AS quality_sum,
          SUM(evds.alignment::float) AS alignment_sum
      FROM observation_reads obr
        LEFT JOIN domain_scores doms
            ON doms.observation_read_id = obr.id
        LEFT JOIN domains dom
            ON doms.domain_id = dom.id
        LEFT JOIN indicator_scores inds
            ON inds.domain_score_id = doms.id
        LEFT JOIN evidence_scores evds
            ON evds.indicator_score_id = inds.id
        WHERE obr.id = #{id}
        GROUP BY obr.id, dom.number
    SQL
  end

  def self.find_section_scores id
     find_by_sql <<-SQL
     SELECT obr.id, 'document' AS Type,
          AVG(evds.quality::float)   AS quality_average, 
          AVG(evds.alignment::float) AS alignment_average,
          SUM(evds.quality::float)   AS quality_sum, 
          SUM(evds.alignment::float) AS alignment_sum
      FROM observation_reads obr
      LEFT JOIN domain_scores doms
           ON doms.observation_read_id = obr.id
      LEFT JOIN domains dom
          ON doms.domain_id = dom.id
      LEFT JOIN indicator_scores inds
          ON inds.domain_score_id = doms.id
      LEFT JOIN evidence_scores evds
          ON evds.indicator_score_id = inds.id
      WHERE dom.number IN (1,4)
        AND obr.id = #{id}
      GROUP BY obr.id
    UNION
      SELECT obr.id, 'live' AS Type,
          AVG(evds.quality::float)   AS quality_average, 
          AVG(evds.alignment::float) AS alignment_average,
          SUM(evds.quality::float)   AS quality_sum, 
          SUM(evds.alignment::float) AS alignment_sum
      FROM observation_reads obr
      LEFT JOIN domain_scores doms
          ON doms.observation_read_id = obr.id
      LEFT JOIN domains dom
          ON doms.domain_id = dom.id
      LEFT JOIN indicator_scores inds
          ON inds.domain_score_id = doms.id
      LEFT JOIN evidence_scores evds
          ON evds.indicator_score_id = inds.id
      WHERE dom.number IN (2,3)
        AND obr.id = #{id}
      GROUP BY obr.id
    SQL
  end

  def self.edit_reader_list_single
    find_by_sql <<-SQL
    SELECT *
    FROM(
      SELECT onea.employee_id_observer,
        onea.id AS document_observation_read_id,
        onea.observation_status AS document_status,
        onea.observer_name AS observer_name,
        onea.reader_id AS document_reader_id,
        oneb.id AS live_observation_read_id,
        oneb.observation_status AS live_status,
        oneb.reader_id AS Live_reader_id,
        two.id AS second_observation_read_id,
        two.reader_id AS second_reader_id,
        two.observation_status AS second_status,
        onea.flagged AS onea_flagged,
        oneb.flagged AS oneb_flagged,
        two.flagged AS two_flagged
         , row_number() OVER(PARTITION BY onea.employee_id_observer ORDER BY onea.observation_group_id DESC) AS obsnum
  --SELECT *
      FROM observation_reads onea
      JOIN observation_reads oneb
        ON oneb.reader_number = '1b'
        AND onea.observation_group_id = oneb.observation_group_id
      JOIN observation_reads two
        ON two.reader_number = '2'
        AND onea.observation_group_id = two.observation_group_id
      WHERE onea.reader_number = '1a'
      ORDER BY onea.employee_id_observer
      ) obs
      WHERE obsnum = 1
    SQL
  end

  def self.edit_reader_list
    find_by_sql <<-SQL
    SELECT onea.employee_id_observer,
      onea.id AS document_observation_read_id,
      onea.observation_status AS document_status,
      onea.observer_name AS observer_name,
      onea.reader_id AS document_reader_id,
      oneb.id AS live_observation_read_id,
      oneb.observation_status AS live_status,
      oneb.reader_id AS Live_reader_id,
      two.id AS second_observation_read_id,
      two.reader_id AS second_reader_id,
      two.observation_status AS second_status,
      onea.flagged AS onea_flagged,
      oneb.flagged AS oneb_flagged,
      two.flagged AS two_flagged
    FROM observation_reads onea
    JOIN observation_reads oneb
      ON oneb.reader_number = '1b'
      AND onea.observation_group_id = oneb.observation_group_id
    JOIN observation_reads two
      ON two.reader_number = '2'
      AND onea.observation_group_id = two.observation_group_id
    WHERE onea.reader_number = '1a'
    ORDER BY onea.employee_id_observer
    --- LIMIT 100
    SQL
  end

end
