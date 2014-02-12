class Reader < ActiveRecord::Base
  attr_accessible :employeenumber, :first_name, :last_name, :email
	validates :email, :presence => true
end
