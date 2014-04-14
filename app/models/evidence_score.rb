class EvidenceScore < ActiveRecord::Base
  attr_accessible :indicator_score_id, :description, :quality, :alignment
  belongs_to :indicator_score
end
