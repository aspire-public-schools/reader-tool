class ObservationsController < ApplicationController
  include SessionHelper
  include EvidenceScoreHelper

  before_filter :require_reader

  def new

  end

	def index
    @reader = current_user
    @observation_reads = @reader.observation_reads
  end

  def show
    @reader = current_user
    @observation_reads = @reader.observation_reads
    @observation_read = @reader.observation_reads.find(params[:id])
    @domains = @observation_read.domains
    if params[:domain_id]
      @indicator = Domains.find(params[:domain_id]).indicators
      if params[:indicator_id]
        @evidence_scores = Indicator.find(params[:indicator_id]).evidence_scores
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