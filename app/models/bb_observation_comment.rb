class BBObservationComment < ActiveRecord::Base
  self.table_name  = "bb_observation_comments"
  self.primary_key = "evidence_id"
end
