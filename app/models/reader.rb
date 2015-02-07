class Reader < ActiveRecord::Base
  has_many :observation_reads
  attr_accessible :employee_number, :first_name, :last_name, :email, :is_reader1a, :is_reader1b, :is_reader2
  validates :first_name, :presence => true
	validates :email, :presence => true
  validates_uniqueness_of :email, :employee_number
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  before_validation :set_defaults, on: :create

  def self.deactive
    where(is_reader1a: "0", is_reader1b: "0", is_reader2: "0")
  end

  def self.active
    Reader.all - Reader.deactive
  end

  def reader1a?
    is_reader1a == "1"
  end

  def reader1b?
    is_reader1b == "1"
  end

  def reader2?
    is_reader2 == "1"
  end

  protected 

  def set_defaults
    self.is_reader1a ||= "1"
    self.is_reader1b ||= "1"
    self.is_reader2  ||= "0"
    self
  end

end
