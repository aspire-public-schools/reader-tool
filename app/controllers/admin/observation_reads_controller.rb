class Admin::ObservationReadsController < AdminController

  def index
    @readers = Reader.all.sort_by(&:first_name)
    @observation_reads = ObservationRead.all
    @readers_for_select_1a = select_for('1a')
    @readers_for_select_1b = select_for('1b')
    @readers_for_select_2  = select_for('2')    
    @edit_reader_list = ObservationRead.edit_reader_list_single
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


  private

  def select_for kind
    output = Reader.where("is_reader#{kind}" => "1").active
    return ["No Readers with #{kind}", "" ] if output.empty?
    output.map{ |reader| [reader.first_name, reader.id] }
  end

end

