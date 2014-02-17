class DomainScore < ActiveRecord::Base
  has_many :indicator_scores
  has_many :indicators, through: :indicator_scores
  has_many :evidences, through: :indicator_scores
  belongs_to :observation_read
  belongs_to :domain
end
