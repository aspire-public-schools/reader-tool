class Indicator < ActiveRecord::Base
  attr_accessible :code, :description, :domain_id, :evidence_score_attributes

  belongs_to :domain
  has_one :indicator_score
  has_many :domain_scores
  has_many :evidence_scores, through: :indicator_scores

  accepts_nested_attributes_for :evidence_score

end