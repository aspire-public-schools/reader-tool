class EvidenceScore < ActiveRecord::Base
  attr_accessible :indicator_score_id, :description
  belongs_to :indicator_score
end