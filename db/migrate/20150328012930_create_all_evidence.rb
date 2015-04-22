class CreateAllEvidence < ActiveRecord::Migration

  def down
    execute "DROP TABLE all_evidence CASCADE"
  end

  def up
    execute "DROP TABLE IF EXISTS all_evidence CASCADE"
    create_table  "all_evidence", :id => false do |t|
      t.integer  "observation_group_id"
      t.string   "employee_id_observer"
      t.string   "observer_name"
      t.string   "employee_id_learner"
      t.integer  "evidence_id"
      t.text     "evidence"
      t.string   "indicator_code"
      t.integer  "row_id"
      t.datetime "created_at"
    end
    
    add_index :all_evidence, :observation_group_id    

    # TODO: use reversible block
    execute <<-SQL.squish
      CREATE OR REPLACE VIEW vw_all_observations AS 
      SELECT DISTINCT all_evidence.observation_group_id,
         all_evidence.employee_id_observer,
         all_evidence.employee_id_learner,
         all_evidence.observer_name,
         all_evidence.created_at
        FROM all_evidence
        WHERE created_at >= (now() - interval '6 months');
    SQL

  end

end
