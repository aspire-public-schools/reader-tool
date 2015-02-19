 class ObservationReadsController < ApplicationController

  def index
    fetch_current_reads
  end

  def show
    fetch_current_reads
    @observation_read = ObservationRead.find(params[:id])
    @domains            = @observation_read.domain_scores
    @domain_percentages = @observation_read.find_percentages.sort_by(&:number)
    @get_section_scores = @observation_read.find_section_scores
    @observation_read.update_scores( @get_section_scores )

    render :index
  end

  def update
    @observation_read = ObservationRead.find(params[:id])

    if @observation_read.update_attributes(params[:observation_read])
      @observation_read.finalize!
      render :json => { :saved_message => "You've Successfully Finalized!", :document_live_form => render_to_string(:partial => "document-live-form", locals: { :observation_read => @observation_read }) }
    else
      render :json => { :error => @observation_read.errors.full_messages.join(", ")}, :status => :unprocessable_entity
    end
  end

  private

  def fetch_current_reads
    @reader = current_user
    @observation_reads = @reader.observation_reads.status(:ready)
  end

end
