class Reader < ActiveRecord::Base
  attr_accessible :employee_number, :first_name, :last_name, :email, :is_reader1a, :is_reader1b, :is_reader2

  has_secure_password
  after_create :send_password_reset

  has_many :observation_reads, order: "created_at DESC"

  validates :first_name, presence: true
	validates :email, presence: true, uniqueness: true, format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_uniqueness_of :employee_number, allow_blank: true


  before_validation :set_defaults, on: :create

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def to_s kind=:long
    case kind
    when :short
      first_with_last_initial
    else
      full_name
    end
  end

  def first_with_last_initial
    "#{first_name} #{last_initials}".strip
  end

  def last_initials
    last_name.split("").select{|c| /[[:upper:]]|-/.match(c) }.join
  end

  def self.deactive
    where(is_reader1a: false, is_reader1b: false, is_reader2: false)
  end

  def self.active
    # TODO: use rails 4  where.not(is_reader1a: false, is_reader1b: false, is_reader2: false)
    Reader.order(:last_name).all - Reader.deactive
  end

  def reader1a?
    is_reader1a?
  end

  def reader1b?
    is_reader1b?
  end

  def reader2?
    is_reader2?
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def temporary_password
    full_name.downcase.split(' ').join
  end

  def make_temporary_password!
    self.password = temporary_password
    save!
  end

  def self.where_not(opts)
    params = []        
    sql = opts.map{|k, v| params << v; "#{quoted_table_name}.#{quote_column_name k} != ?"}.join(' AND ')
    where(sql, *params)
  end

  def set_defaults
    self.is_reader1a ||= true
    self.is_reader1b ||= true
    self.is_reader2  ||= false
    self.password    ||= temporary_password
    self
  end


  private

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while Reader.exists?(column => self[column])
  end

end
