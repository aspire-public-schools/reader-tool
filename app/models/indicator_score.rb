class IndicatorScore < ActiveRecord::Base
  attr_accessible :comments
  has_many :evidence_scores
  has_one :indicator
  belongs_to :indicator
  belongs_to :domain_score

  accepts_nested_attributes_for :evidence_scores

	def modified?
		if self.modified_at != nil
			return self.modified_at > self.created_at
		end
			return false
	end

end



