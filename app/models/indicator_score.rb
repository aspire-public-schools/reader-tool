class IndicatorScore < ActiveRecord::Base
  has_many :evidence_scores
  belongs_to :indicator
  belongs_to :domain_score
end