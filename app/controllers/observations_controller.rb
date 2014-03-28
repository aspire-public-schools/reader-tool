class ObservationsController < ApplicationController
  include EvidenceScoreHelper

  before_filter :require_reader

	def index
    @reader = current_user
    @observation_reads = @reader.observation_reads
    @observation_reads = @reader.observation_reads.where(observation_status: 2)
    @domains = Domain.all
    @domain = Domain.all    ## OBSERVATION HAS MANY DOMAINS
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
    @observation_reads = @reader.observation_reads.where(observation_status: 2)
    # p "-------------------------------------------------"
    # p @observation_read_reader2 = @reader.observation_reads.where(reader_number: "2")
    #@observation_reads += @reader.observation_reads.where(observation_status: 2, reader_number: '2')
    @observation_read = @reader.observation_reads.find(params[:id])
    @domains = @observation_read.domain_scores
    if params[:domain_id]
      @indicator = Domain.find(params[:domain_id]).indicators
      if params[:indicator_id]
        @evidence_scores = Indicator.find(params[:indicator_id]).evidence_scores # ON THIS PAGE: 1 observation, ALL DOMAINS
      end
    end

    @domain_percentages = get_percentages(params[:id])
    @get_section_scores = get_section_scores(params[:id])
    @domain_percentages.sort! { |a,b| a.number <=> b.number }
    @domain = Domain.all
    render 'index'
  end

  def update
    @observation_read = ObservationRead.find(params[:id])
    if @observation_read.update_attributes(params[:observation_read]) && @observation_read.copy_to_reader2
      @observation_read.update_status
      render :json => { :saved_message => "You've Successfully Finalized!", :document_live_form => render_to_string(:partial => "document-live-form", locals: { :observation_read => @observation_read } ) }
    elsif @observation_read.update_attributes(params[:observation_read])
      @observation_read.update_attributes(observation_status: 3)
      render :json => { :saved_message => "You've Successfully Finalized!", :document_live_form => render_to_string(:partial => "document-live-form", locals: { :observation_read => @observation_read } ) }
    else
      render :json => { :error => @observation_read.errors.full_messages.join(", ")}, :status => :unprocessable_entity
    end

  end

  private

  def require_reader
    redirect_to "/login" unless current_user
  end

end
    #TODO Save section scores
    # Done     IF reader 1a or 1b then copy 1a/b scores into 2
    #          Set observation_status for reader 1a/b to 3.
    #          If both 1a & 1b are 3 then set reader 2 to 2
