class Admin::DashboardController < ApplicationController

  def index
    observation_reads = ObservationRead.all
  end

end

