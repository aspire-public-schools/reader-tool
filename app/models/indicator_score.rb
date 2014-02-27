class IndicatorScore < ActiveRecord::Base
  has_many :evidence_scores
  has_one :indicator
  belongs_to :indicator
  belongs_to :domain_score
end