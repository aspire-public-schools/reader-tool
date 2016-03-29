 class ObservationReadsController < ApplicationController

  def index
    @observation_reads = current_user.observation_reads.status(:ready)
    @waiting_reads     = current_user.observation_reads.status(:waiting)
    @finalized_reads   = current_user.observation_reads.status(:finished)
  end

  def show
    @observation_read = ObservationRead.find(params[:id])
    @domains          = @observation_read.domain_scores.order("domain_id ASC")
    @domain_scores    = @observation_read.find_scores_by_domain_number

    @domain_numbers = Domain.all_numbers
    @dropdown = ObservationRead::STATES.map.with_index{|state,idx| [state, idx+1]}
  end

  def update
    @observation_read = ObservationRead.find(params[:id])
    if @observation_read.update_attributes(params[:observation_read])
      @observation_read.finalize!
      messages = {success: "You've Successfully Finalized!"}
    else
      messages = {error: @observation_read.errors.full_messages.join(", ")}
    end
    redirect_to observation_reads_path, flash: messages
  end

end
