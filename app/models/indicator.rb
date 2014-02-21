class Indicator < ActiveRecord::Base
  attr_accessible :code, :description, :domain_id

  belongs_to :domain
  has_many :indicator_scores
  has_many :domain_scores, through: :indicator_scores
end