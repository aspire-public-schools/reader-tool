class ObservationsController < ApplicationController
  include SessionHelper

  def new
    @evidence_score = EvidenceScore.new
  end


	def index
    # p "I'm hereeeeeeee"
    # p session
    @reader = current_user
    if current_user
      @observation_reads = @reader.observation_reads

    #   # @observation_reads.each do |observation_read|

    #   #   observation_read.domain_scores


    #   #   @domain_scores.each do |@domain|
    #   #     domain_score.indicator_scores
    #   #   end
    end
    @domain = Domain.all
  end

  def show
    @reader = current_user
    @observation_reads = @reader.observation_reads
    @domain = Domain.all
  end

end


