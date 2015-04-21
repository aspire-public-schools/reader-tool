class ObservationRead < ActiveRecord::Base
  attr_accessible :document_quality, :document_alignment, :live_alignment, :live_quality, :observation_status, :id, :observation_group_id, :employee_id_observer, :employee_id_learner, :correlation, :average_difference, :percent_correct, :reader_id, :created_at, :updated_at, :reader_number, :comments, :flagged
  has_many :domain_scores
  has_many :domains, through: :domain_scores, uniq: true
  has_many :indicator_scores, through: :domain_scores
  has_many :evidence_scores,  through: :indicator_scores
  belongs_to :reader

  STATES = %w[ NOTCERT CERT ]

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

  def copy_to_reader2
    r1_observation_read = self
    r2_observation_read = ObservationRead.where("observation_group_id = ? AND reader_number = ?", self.observation_group_id, '2').first

    case reader_number
    when '1a'
      certification_scores = {:document_quality => self.document_quality, :document_alignment => self.document_alignment}
    when '1b'
      certification_scores = {:live_quality => self.live_quality, :live_alignment => self.live_alignment}
    end

    # initialize reader 2 observation with comments from reader 1a
    r2_observation_read.update_attributes(certification_scores)
    comments = "#{self.reader_number}: #{self.comments}"
    comments += "\n#{r2_observation_read.comments}" if r2_observation_read.comments.present? && r2_observation_read.comments != self.comments

    r2_observation_read.update_attributes(comments: comments)

    case reader_number
    when '1a'
      r2_indicator_scores = r2_observation_read.indicator_scores.where("domain_scores.domain_id IN (1,4)").order(:indicator_id)
    when '1b'
      r2_indicator_scores = r2_observation_read.indicator_scores.where("domain_scores.domain_id IN (2,3)").order(:indicator_id)
    end

    if reader_number == '1a' || reader_number == '1b'
    # this copies reader 1 scores into reader 2
      r1_indicator_scores = r1_observation_read.indicator_scores.order(:indicator_id)

      r2_indicator_scores.count.times{ |i|
          r2_indicator_scores[i].update_attributes(:comments => r1_indicator_scores[i].comments )

          sorted_r1_indicator_scores = r1_indicator_scores[i].evidence_scores.order(:description)
          sorted_r2_indicator_scores = r2_indicator_scores[i].evidence_scores.order(:description)

            r1_indicator_scores[i].evidence_scores.count.times { |j|

                 new_scores = {:quality => sorted_r1_indicator_scores[j].quality, :alignment => sorted_r1_indicator_scores[j].alignment }

                 sorted_r2_indicator_scores[j].update_attributes(new_scores)

            }
        }
    end
  end

  def finalize!
    copy_to_reader2
    update_attributes(observation_status: 3) # finished
    # if 1a and 1b are both finished then 2 goes to ready
    completed_group_reads = ObservationRead.where(observation_group_id: self.observation_group_id, reader_number: ['1a','1b'], observation_status: 3)
    if completed_group_reads.count == 2
      read_2 = ObservationRead.where(observation_group_id: self.observation_group_id, reader_number: '2').first
      read_2.update_attributes(observation_status: 2) # ready
    end
  end

  # this gets called from IndicatorScoresController#update
  def update_scores!
    scores = find_section_scores

    if score = scores[0]
      document_quality   = quality_cert( score )
      document_alignment = alignment_cert( score )
    end

    if final && score = scores[1]
      live_quality   = quality_cert( score )
      live_alignment = alignment_cert( score )
    end

    save!
  end

  def quality_cert score
    score.quality_average.to_f*100 >= 80 ? 2 : 1
  end

  def alignment_cert score
    score.alignment_average.to_f*100 >= 75 ? 2 : 1
  end

  def find_scores_by_domain_number
    output = self.class.find_scores_by_domain_number(self.id)
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

  def self.find_scores_by_domain_number id
    find_by_sql <<-SQL
      SELECT obr.id, dom.number,
          AVG(evds.quality::integer)   AS quality_average, 
          AVG(evds.alignment::integer) AS alignment_average,
          SUM(evds.quality::integer)   AS quality_sum,
          SUM(evds.alignment::integer) AS alignment_sum
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
          AVG(evds.quality::integer)   AS quality_average, 
          AVG(evds.alignment::integer) AS alignment_average,
          SUM(evds.quality::integer)   AS quality_sum, 
          SUM(evds.alignment::integer) AS alignment_sum
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
          AVG(evds.quality::integer)   AS quality_average, 
          AVG(evds.alignment::integer) AS alignment_average,
          SUM(evds.quality::integer)   AS quality_sum, 
          SUM(evds.alignment::integer) AS alignment_sum
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
