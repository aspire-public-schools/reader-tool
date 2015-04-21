class Evidence < ActiveRecord::Base
  self.table_name = "all_evidence"
  self.primary_key = "evidence_id"

  def self.truncate!
    connection.execute "TRUNCATE TABLE all_evidence;"
  end
end
