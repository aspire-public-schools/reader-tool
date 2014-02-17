class Domain < ActiveRecord::Base
  has_many :domain_scores
  has_many :indicators
end