class Evidence < ActiveRecord::Base
  has_many :indicator_scores
  has_many :domain_scores, through: :indicator_scores
  has_many :indicators, through: :indicator_scores
end