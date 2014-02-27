class Domain < ActiveRecord::Base
  attr_accessible :number, :description, :indicators_attributes
  has_many :domain_scores
  has_many :indicators

  accepts_nested_attributes_for :indicators
end
