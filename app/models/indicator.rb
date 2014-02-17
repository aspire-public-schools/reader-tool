class Indicator < ActiveRecord::Base
  belongs_to :domain
  has_many :indicator_scores
  has_many :domain_scores, through: :indicator_scores
end