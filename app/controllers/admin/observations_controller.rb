class Admin::ObservationsController < ApplicationController
  include ApplicationHelper

  def index
    @readers = Reader.all.sort
    @observation_reads = ObservationRead.all
    @readers_for_select = Reader.active.map { |reader| [reader.first_name, reader.id] }
    @edit_reader_list = edit_reader_list
  end

  def update
      if params[:observation_read_id]
          params[:observation_read_id].each do |observation_id|
           ObservationRead.update(observation_id[0], {reader_id: observation_id[1]})
          end
        redirect_to admin_observations_path, :flash => { :success => "Your changes were saved!" }
      else
        redirect_to admin_observations_path, :flash => { :error => "Your changes didn't save, contact Godzilla"}
      end
  end

end
