class ObservationRead < ActiveRecord::Base
  has_many :indicators_scores
  has_many :domains, through: :indicators_scores
  has_many :indicators, through: :indicators_scores
end