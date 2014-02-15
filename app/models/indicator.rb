class Indicator < ActiveRecord::Base
  has_many :domains
  has_many :indicator_scores
  has_many :domain_scores, through: :indcator_scores
end