class ObservationsController < ApplicationController
  include EvidenceScoreHelper

  before_filter :require_reader

	def index
    @reader = current_user
    debugger
    @observation_reads = @reader.observation_reads
    @observation_reads = @reader.observation_reads.where(observation_status: 1, reader_number: ['1a', '1b'])
    @observation_reads += @reader.observation_reads.where(observation_status: 2, reader_number: '2')
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
    @observation_reads = @reader.observation_reads.where(observation_status: 1, reader_number: ['1a', '1b'])
    @observation_reads += @reader.observation_reads.where(observation_status: 2, reader_number: '2')
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
    p "Im about to update!--------------"
    # p ObservationRead.count
    @observation_read = ObservationRead.find(params[:id])

    if @observation_read.complete
    # if @observation_read.update_attributes(params[:observation_read])
      render :json => { :saved_message => "You've Successfuly Submitted the Certifications!", :document_live_form => render_to_string(:partial => "document-live-form", locals: { :observation_read => @observation_read } ) }
    else
      render :json => { :error => reader.errors.full_messages.join(", ")}, :status => :unprocessable_entity
    end
    p ObservationRead.count
  end

  private

  def require_reader
    redirect_to "/login" unless current_user
  end

end
