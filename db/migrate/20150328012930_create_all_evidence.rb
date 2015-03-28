class CreateAllEvidence < ActiveRecord::Migration
  def change
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
  end
end
