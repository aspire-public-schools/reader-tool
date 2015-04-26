class ChangeAllObservationViewToLast3Months < ActiveRecord::Migration
  def up
    execute <<-SQL.squish
      CREATE OR REPLACE VIEW vw_all_observations AS 
      SELECT DISTINCT all_evidence.observation_group_id,
         all_evidence.employee_id_observer,
         all_evidence.employee_id_learner,
         all_evidence.observer_name,
         all_evidence.created_at
        FROM all_evidence
        WHERE created_at >= (now() - interval '3 months');
    SQL
  end

  def down
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
