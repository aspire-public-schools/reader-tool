class Admin::ObservationsController < ApplicationController

  def create
    render 'index'
  end

  def index
    @observation_reads = ObservationRead.all.uniq { |r| r.employee_id_observer }.sort_by { |r| r.employee_id_observer }
    @readers = Reader.all.map { |reader| [reader.first_name, reader.id] }
    # render 'update'
  end

  def update

    redirect_to admin_observations_path
  end

  def show
  end

  # def update_readers
  #   Observation_read.update_all(id: params[:observation_read_ids])
  #   redirect admin_observation_path
  # end


end
