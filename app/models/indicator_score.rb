class IndicatorScore < ActiveRecord::Base
  attr_accessible :comments, :evidence_scores_attributes

  belongs_to :indicator
  belongs_to :domain_score
  delegate :domain, :domain_number, to: :domain_score
  delegate :code, :description, to: :indicator, prefix: true

  has_one :observation_read, through: :domain_score

  has_many :evidence_scores, order: :id

  accepts_nested_attributes_for :evidence_scores

	def updated?
		created_at - updated_at > 1.second
	end

  def to_s
    "#{indicator_code}: #{indicator_description}"
  end

end