class ObservationsController < ApplicationController
  include EvidenceScoreHelper

  before_filter :require_reader

	def index
    @reader = current_user
    @observation_reads = @reader.observation_reads
    @observation_read = @reader.observation_reads
    @domains = Domain.all
    @domain = Domain.all    ## OBSERVATION HAS MANY DOMAINS
    p "********************************************"
    p params[:domain_id]
    if params[:domain_id]
        @indicator = Domain.find(params[:domain_id]).indicators
      if params[:indicator_id]
        @evidence_scores = Indicator.find(params[:indicator_id]).evidence_scores
      end
    end
    render 'index'
  end

  def show
    @reader = current_user
    @observation_reads = @reader.observation_reads
    p "i'm here------------------------------"
    p @observation_read = @reader.observation_reads.find(params[:id])
    @domains = @observation_read.domain_scores
    if params[:domain_id]
      @indicator = Domain.find(params[:domain_id]).indicators
      if params[:indicator_id]
        @evidence_scores = Indicator.find(params[:indicator_id]).evidence_scores # ON THIS PAGE: 1 observation, ALL DOMAINS
      end
    end
    @domain_percentages = get_percentages(params[:id])
    @domain_percentages_sort = @domain_percentages.sort! { |a,b| a.number <=> b.number }
    @domain = Domain.all
    render 'index'
  end

  def update
   @reader = current_user
   @observation_read = @reader.observation_reads.find(params[:id])
   render 'index'
  end


  private

  def require_reader
    redirect_to "/login" unless current_user
  end

end