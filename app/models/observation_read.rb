class ObservationRead < ActiveRecord::Base
  has_many :domain_scores
  belongs_to :reader
end