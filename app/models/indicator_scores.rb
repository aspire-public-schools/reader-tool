class IndicatorScore < ActiveRecord::Base
  t.belongs_to :evidence
  t.belongs_to :indicator
  t.belongs_to :domain_scores
end