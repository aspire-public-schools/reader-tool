class Admin::ObservationsController < ApplicationController
  include ApplicationHelper

  def create
    render 'index'
  end

  def index
    @readers = Reader.all.map { |reader| [reader.first_name, reader.id] }
    @edit_reader_list = edit_reader_list
  end

  def update
    if params[:observation_read_id]
        params[:observation_read_id].each do |observation_id|
         ObservationRead.update(observation_id[0], {reader_id: observation_id[1]})
      end
      redirect_to admin_observations_path
     end
  end

end
