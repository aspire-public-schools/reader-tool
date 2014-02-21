class EvidenceScore < ActiveRecord::Base
  attr_accessible :indicator_score_id, :description
  belongs_to :indicator_score
  validates :evidence_score, inclusion: {in: [true, false]}
end