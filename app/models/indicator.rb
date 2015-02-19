class Indicator < ActiveRecord::Base
  attr_accessible :code, :description, :domain_id, :evidence_score_attributes

  belongs_to :domain

  has_one :indicator_score
  
  has_one :domain_score,     through: :indicator_score
  has_many :evidence_scores, through: :indicator_scores

end