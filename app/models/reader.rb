class Reader < ActiveRecord::Base
  has_many :observation_reads

  attr_accessible :employee_number, :first_name, :last_name, :email
	validates :email, :presence => true

end
