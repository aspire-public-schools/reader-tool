class IndicatorScore < ActiveRecord::Base
  belongs_to :evidence
  belongs_to :indicator
  belongs_to :domain_score
end