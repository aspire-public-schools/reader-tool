module TableImporter
  extend self

  MODELS = %w[ DomainScore IndicatorScore EvidenceScore ObservationRead ]

  def import_from_csv file_path, truncate=true
    run_sql Rails.root.join('db','create_evidence_table.sql'), "creating table"
    run_sql "COPY all_evidence FROM '#{file_path}' DELIMITER ',' CSV HEADER;", "importing csv"
    truncate_tables! if truncate
    run_sql Rails.root.join('db','transform_raw_evidence.sql'), "transforming evidence"
  end

  private

  def run_sql sql, msg=nil
    sql = sql.read if sql.is_a? Pathname
    Rails.logger.info "#{msg}..." if msg
    ActiveRecord::Base.connection.execute sql
    Rails.logger.info "#{msg} done!" if msg
  end

  def directory cmo_name
    Rails.root.join( "tmp", cmo_name, "import" )
  end

  def truncate_tables!
    run_sql MODELS.map{ |model| "TRUNCATE table #{model.tableize};" }.join
  end

end