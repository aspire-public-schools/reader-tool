class ObservationsController < ApplicationController
  include SessionHelper

	def index
    # p "I'm hereeeeeeee"
    # p session
    @reader = current_user
    if current_user
      @observation_reads = @reader.observation_reads
    end
    @domain = Domain.all
  end

  def show
    @reader = current_user
    @observation_reads = @reader.observation_reads

    @domain = Domain.all
  end

end

