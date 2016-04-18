class CertificationTeacher < ActiveRecord::Base
  self.table_name  = "current_certification_teacher"
  self.primary_key = "id"

  def create #This table is designed to only hold a single record.  If you need to add more records, need to rewrite SQL in the ObservationRead model
  end
  
end