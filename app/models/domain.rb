class Domain < ActiveRecord::Base
  attr_accessible :number, :description
  has_many :domain_scores
  has_many :indicators
end