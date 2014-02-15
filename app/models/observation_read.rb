class ObservationRead < ActiveRecord::Base
  has_many :domain_scores
end