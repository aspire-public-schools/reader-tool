class BBIndicator < ActiveRecord::Base
  self.table_name  = "bb_indicators"
  self.primary_key = "indicator_id"
end
