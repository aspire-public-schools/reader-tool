 class ObservationReadsController < ApplicationController

  def index
    @observation_reads = current_user.observation_reads.status(:ready)
  end

  def show
    @observation_read = ObservationRead.find(params[:id])
    @domains          = @observation_read.domain_scores
    @domain_scores    = @observation_read.find_scores_by_domain_number

    @domain_numbers = Domain.all_numbers
    @dropdown = ObservationRead::STATES.map.with_index{|state,idx| [state, idx+1]}
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

end
