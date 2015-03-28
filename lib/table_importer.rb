module TableImporter
  extend self

  MODELS = %w[ DomainScore IndicatorScore EvidenceScore ObservationRead ]

  def import_from_csv file_path, truncate=false
    truncate_tables! if truncate
    execute begin <<-SQL
      TRUNCATE TABLE all_evidence;
      COPY all_evidence FROM '#{file_path}'
        DELIMITER ',' CSV HEADER;
    SQL
    end , "importing csv"

    # TODO: http://stackoverflow.com/questions/4069718/postgres-insert-if-does-not-exist-already
    execute Rails.root.join('db','transform_raw_evidence.sql'), "transforming evidence"
  end

  private

  def execute sql, msg=nil
    sql = sql.read if sql.is_a? Pathname
    Rails.logger.info "#{msg}..." if msg
    ActiveRecord::Base.connection.execute sql
    Rails.logger.info "#{msg} done!" if msg
  end

  def directory cmo_name
    Rails.root.join( "tmp", cmo_name, "import" )
  end

  def truncate_tables!
    execute MODELS.map{ |model| "TRUNCATE table #{model.tableize};" }.join
  end

end