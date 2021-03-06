class Reader < ActiveRecord::Base
  has_many :observation_reads
  attr_accessible :employee_number, :first_name, :last_name, :email, :is_reader1a, :is_reader1b, :is_reader2
  validates :first_name, :presence => true
	validates :email, :presence => true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  def self.deactive
    where(is_reader1a: "0", is_reader1b: "0", is_reader2: "0")
  end

  def self.active
    Reader.all - Reader.deactive
  end

  def show_yes_no
    self.send(attribute) == 1 ? "Yes" : "No"
    if is_reader1a == "1" || is_reader1b == "1" || is_reader2 == "1"
      "Yes"
    else
      "No"
    end
  end

  def reader2?
    is_reader2 == "1"
  end

end
