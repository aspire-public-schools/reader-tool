class ObservationsController < ApplicationController
  include SessionHelper
  include EvidenceScoreHelper

  before_filter :require_reader

  def new

  end

	def index
    # debugger  # ROUTING OBSERVATION INDEX -> localhost://3000/observations/3
    @reader = current_user
    @observation_reads = @reader.observation_reads
    @observation_read = @reader.observation_reads # READER -> OBSERVATIONS
    @domains = Domain.all    ## OBSERVATION HAS MANY DOMAINS
    if params[:domain_id]
      @indicator = Domains.find(params[:domain_id]).indicators
      if params[:indicator_id]
        @evidence_scores = Indicator.find(params[:indicator_id]).evidence_scores
      end
    end
    @domain = Domain.all
    render 'index'
  end

  def show
    @reader = current_user
    @observation_reads = @reader.observation_reads
    @observation_read = @reader.observation_reads.find(params[:id])
    @domains = @observation_read.domain_scores
    if params[:domain_id]
      @indicator = Domains.find(params[:domain_id]).indicators
      if params[:indicator_id]
        @evidence_scores = Indicator.find(params[:indicator_id]).evidence_scores # ON THIS PAGE: 1 observation, ALL DOMAINS
      end
    end
    @domain = Domain.all
    render 'index'
  end

  private

  def require_reader
    redirect_to "/login" unless current_user
  end

end