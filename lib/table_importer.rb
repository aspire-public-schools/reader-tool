module TableImporter
  extend self

  MODELS = %w[ DomainScore IndicatorScore EvidenceScore ObservationRead ]

  def import_from_csv file_path, truncate=false
    truncate_tables! if truncate
    import_all_evidence! file_path
    populate!
  end

  private

  def import_all_evidence! file_path
    Evidence.truncate!
    Evidence.pg_copy_from file_path, map: {
      'Observation_Group_ID'     => 'observation_group_id',
      'employee_ID_observer'     => 'employee_id_observer',
      'observer_name'            => 'observer_name',
      'employee_id_learner'      => 'employee_id_learner',
      'evidence_id'              => 'evidence_id',
      'evidence'                 => 'evidence',
      'Indicator_Code'           => 'indicator_code',
      'RowID'                    => 'row_id',
      'Observation_Created_Date' => 'created_at'
    }
  end

  def populate!
    populate_observation_reads
    execute POPULATE_DOMAIN_SCORES,     "populating domain scores"
    execute POPULATE_INDICATOR_SCORES,  "populating indicator scores"
    execute POPULATE_EVIDENCE_SCORES ,  "populating evidence scores"
  end

  def execute sql, msg=nil
    sql = sql.read if sql.is_a? Pathname
    Rails.logger.info "#{msg}..." if msg
    t_start = Time.now
    ActiveRecord::Base.connection.execute sql
    t_stop = Time.now
    seconds = (t_stop-t_start)
    minutes, seconds = seconds.divmod(60)
    Rails.logger.info "#{msg} done! (#{minutes}:#{seconds.round} elapsed)" if msg
  end

  def directory cmo_name
    Rails.root.join( "tmp", cmo_name, "import" )
  end

  def truncate_tables!
    execute MODELS.map{ |model| "TRUNCATE table #{model.tableize};" }.join
  end

  READER_TYPES = %w[ 1a 1b 2 ]
  # def assign_reader!(kind)
  #   raise ArgumentError, "reader type must be one of: #{READER_TYPES.join(', ')}" unless READER_TYPES.include?(kind.to_s)

  #   execute begin <<-SQL
  #     INSERT INTO observation_reads (observation_group_id,employee_id_observer,employee_id_learner,reader_number,reader_id,document_quality,document_alignment,observation_status)
  #       SELECT observation_group_id, employee_id_observer, employee_id_learner, reader_number, readers.id AS reader_id, 1 AS document_quality, 1 AS document_alignment,2 AS observation_status
  #       FROM(
  #         SELECT DISTINCT observation_group_id, employee_id_observer, employee_id_learner,
  #           '#{kind}' AS reader_number,
  #           ROW_NUMBER() OVER(ORDER BY observation_group_id) -1 AS obs_num 
  #         FROM vw_all_observations obs
  #         WHERE observation_group_id NOT IN (  --This is error checking code to prevent creating duplicate observation_reads
  #             SELECT DISTINCT observation_group_id FROM observation_reads WHERE reader_number = '#{kind}'
  #           )
  #           AND (SELECT COUNT(*) FROM all_evidence evd WHERE evd.observation_group_id = obs.observation_group_id) > 10 --If the observer tagged less than 10 pieces of evidence it's probably bad data and shouldn't be read              
  #       ) obs
  #       LEFT JOIN
  #         (SELECT *, ROW_NUMBER() OVER(ORDER BY employee_number) -1 AS reader_num
  #           FROM readers
  #           WHERE is_reader#{kind} = '1'
  #         ) readers --This uses the modulo operator to equitably distribute the reads
  #         ON obs.obs_num % (SELECT COUNT(*) FROM readers WHERE is_reader#{kind} = '1') = readers.reader_num;
  #   SQL
  #   end , "assigning reader #{kind}"
  # end

  def populate_observation_reads
    READER_TYPES.each do |kind|
      status = kind == '2' ? 2 : 1  # ready if 1a or 1b, waiting if 2
      execute begin <<-SQL
        INSERT INTO observation_reads (observation_group_id,employee_id_observer,employee_id_learner,reader_number,document_quality,document_alignment,observation_status,observer_name)
          SELECT observation_group_id, employee_id_observer, employee_id_learner, '#{kind}' as reader_number, 1 AS document_quality, 1 AS document_alignment,{status} AS observation_status, observer_name
          FROM(
            SELECT DISTINCT observation_group_id, employee_id_observer, employee_id_learner, observer_name,
              '#{kind}' AS reader_number
            FROM vw_all_observations obs
            WHERE observation_group_id NOT IN (  --This is error checking code to prevent creating duplicate observation_reads
                SELECT DISTINCT observation_group_id FROM observation_reads WHERE reader_number = '#{kind}'
              )
              AND (SELECT COUNT(*) FROM all_evidence evd WHERE evd.observation_group_id = obs.observation_group_id) > 10 --If the observer tagged less than 10 pieces of evidence it's probably bad data and shouldn't be read              
          ) obs
      SQL
      end , "populating observation reads for reader #{kind}"
    end
  end

  POPULATE_DOMAIN_SCORES = <<-SQL
  /* POPULATE DOMAIN SCORES - Currently not using domain 5 in the reader tool.  Only create domain_scores for the
  appropriate 1a/1b/2 reader */

  INSERT INTO domain_scores (observation_read_id,domain_id)
    SELECT obs.id AS observation_read_id, dom.id AS domain_id
    FROM observation_reads obs
    CROSS JOIN domains dom
    LEFT JOIN domain_scores domcheck
      ON obs.id = domcheck.observation_read_id AND dom.id = domcheck.domain_id
      AND dom.id <> '5'
      AND domcheck.id IS NULL
  SQL

  POPULATE_INDICATOR_SCORES = <<-SQL
  /* POPULATE INDICATOR SCORES - Currently not using domain 5 and only 4.1A and 4.1B from dom 4 */
  INSERT INTO indicator_scores (domain_score_id, indicator_id, alignment_score,comments)
    SELECT doms.id AS domain_score_id, ind.id AS indicator_id, NULL as alignment_score, null as comments
    FROM Observation_Reads obs
    LEFT JOIN domain_scores doms
      ON doms.observation_read_id = obs.id
    INNER JOIN domains dom
      ON doms.domain_id = dom.id
    INNER JOIN indicators ind
      ON ind.domain_id = dom.id
    LEFT JOIN indicator_scores indcheck
      ON doms.id = indcheck.domain_score_id AND ind.id = indcheck.indicator_id
    WHERE ind.domain_id <> '5'
      AND (ind.domain_id <> '4' OR ind.Code in('4.1A', '4.1B')) 
      AND indcheck.id IS NULL;
  SQL

  POPULATE_EVIDENCE_SCORES = <<-SQL
  /* Generate evidence scores.  Join to other tables to ensure the correct id is inserted */
  INSERT INTO evidence_scores(evidence_id,indicator_score_id,description,quality,alignment)
    SELECT evid.evidence_id AS evidence_id, inds.id AS indicator_score_id, evid.evidence AS description, '1' AS quality, '1' AS alignment
    FROM Observation_Reads obs
    LEFT JOIN domain_scores dom
      ON dom.observation_read_id = obs.id
    LEFT JOIN indicator_scores inds
      ON inds.domain_score_id = dom.id
    LEFT JOIN indicators ind
      ON inds.indicator_id = ind.id
    INNER JOIN all_evidence evid
      ON obs.observation_group_id = evid.observation_group_id AND LEFT(evid.indicator_code,3) || RIGHT(evid.indicator_code,1) = ind.Code --Bloomboard uses two dots while we use one (1.1.A vs 1.1A)
    LEFT JOIN evidence_scores evdcheck
      ON inds.id = evdcheck.indicator_score_id AND evid.evidence_id = evdcheck.evidence_id
    WHERE  evdcheck.id IS NULL
  SQL

end