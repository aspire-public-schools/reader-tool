class Indicator < ActiveRecord::Base
  attr_accessible :code, :description, :domain_id, :evidence_score_attributes

  belongs_to :domain
  has_one :indicator_score
  has_one :evidence_score, through: :indicator_scores
  has_many :domain_scores

  accepts_nested_attributes_for :evidence_score

end