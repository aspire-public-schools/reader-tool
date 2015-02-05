class Admin::ObservationReadsController < AdminController

  def index
    @readers = Reader.all.sort_by(&:first_name)
    @observation_reads = ObservationRead.all
    @readers_for_select = Reader.active.map{ |reader| [reader.first_name, reader.id] }
    @edit_reader_list = ObservationRead.edit_reader_list
  end

  def update
    flash = {}
    if params[:observation_read_id]
      params[:observation_read_id].each do |observation_id|
        ObservationRead.update(observation_id[0], {reader_id: observation_id[1]})
      end
      flash[:success] = "Your changes were saved!"
    else
      flash[:error] = "Your changes didn't save, contact the system Administrator"
    end
    redirect_to admin_observation_reads_path, :flash => flash
  end

end

