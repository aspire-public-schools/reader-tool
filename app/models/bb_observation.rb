class BBObservation < ActiveRecord::Base
  self.table_name  = "bb_observations"
  self.primary_key = "observation_group_id"
end
