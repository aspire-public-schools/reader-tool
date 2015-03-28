class CreateAllEvidence < ActiveRecord::Migration

  def down
    execute "DROP TABLE all_evidence CASCADE"
  end

  def up
    create_table "all_evidence", :id => false, :force => true do |t|
      t.integer "observation_group_id"
      t.string  "employee_id_observer"
      t.string  "observer_name"
      t.string  "employee_id_learner"
      t.integer "evidence_id"
      t.text    "evidence"
      t.string  "indicator_code"
    end
    
    # remove_timestamps :all_evidence # why are these added by default?

    # TODO: use reversible block
    execute <<-SQL.squish
      CREATE OR REPLACE VIEW vw_all_observations AS 
      SELECT DISTINCT all_evidence.observation_group_id,
         all_evidence.employee_id_observer,
         all_evidence.employee_id_learner
        FROM all_evidence;
    SQL

    TableImporter::MODELS.map(&:tableize).each do |table_name|
      add_default_now(table_name, :created_at)
      add_default_now(table_name, :updated_at)
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
