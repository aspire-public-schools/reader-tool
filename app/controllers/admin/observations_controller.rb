class Admin::ObservationsController < ApplicationController

  def index
    @observation_reads = ObservationRead.all
  end



end