class DomainScore < ActiveRecord::Base
  belongs_to :observation_read
  belongs_to :domain
  delegate :description, to: :domain

  has_many :indicator_scores, include: :indicator, order: 'indicators.code'

  has_many :indicators,      through: :indicator_scores
  has_many :evidence_scores, through: :indicator_scores
end
