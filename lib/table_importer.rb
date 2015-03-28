module TableImporter
  extend self
# 1a: 1002000msec
# 1b: 876091msec
# 2

  MODELS = %w[ DomainScore IndicatorScore EvidenceScore ObservationRead ]

  def import_from_csv file_path, truncate=true
    execute Rails.root.join('db','create_evidence_table.sql'), "creating table"
    execute "COPY all_evidence FROM '#{file_path}' DELIMITER ',' CSV HEADER;", "importing csv"
    truncate_tables! if truncate
    update_timestamps!
  # http://stackoverflow.com/questions/4069718/postgres-insert-if-does-not-exist-already
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

  def update_timestamps!
    MODELS.map(&:tableize).each do |table_name|
      add_default_now(table_name, :created_at)
      add_updated_at_trigger(table_name)
    end
  end


  # https://gist.github.com/cee-dub/1700591

  def add_updated_at_trigger(table_name)
    define_trigger_function = <<-SQL.squish
      CREATE OR REPLACE FUNCTION set_updated_at_column() RETURNS TRIGGER AS $$
      BEGIN
         NEW.updated_at = CURRENT_TIMESTAMP AT TIME ZONE 'UTC'; 
         RETURN NEW;
      END;
      $$ language 'plpgsql';
    SQL
    drop_trigger_if_exists = "DROP TRIGGER IF EXISTS set_updated_at_#{table_name} ON #{table_name};"
    create_trigger = <<-SQL.squish
      CREATE TRIGGER set_updated_at_#{table_name}
        BEFORE UPDATE ON #{table_name} FOR EACH ROW
        EXECUTE PROCEDURE set_updated_at_column();
    SQL
    execute define_trigger_function
    execute drop_trigger_if_exists
    execute create_trigger
  end

  def add_default_now(table_name, column_name)
    set_not_null = <<-SQL.squish
      ALTER TABLE #{table_name}
        ALTER COLUMN #{column_name}
          SET NOT NULL;
    SQL
    set_default = <<-SQL.squish
      ALTER TABLE #{table_name}
        ALTER COLUMN #{column_name}
          SET DEFAULT CURRENT_TIMESTAMP AT TIME ZONE 'UTC';
    SQL
    execute set_not_null
    execute set_default
  end

end