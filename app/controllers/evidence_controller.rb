class EvidenceController < ApplicationController

  def create
    @evidence_score = EvidenceScore.new
  end
end
