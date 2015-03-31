module ObservationReadsHelper

  def print_cert value
    @dropdown.find{|d| d.last == value }.try(:first)
  end

  def print_reader_number observation_read
    case observation_read.reader_number
    when '1a'
      '1'
    when '1b'
      '2'
    when '2'
      '3'
    end
  end

  def highlight_if_showing obs
    # p "obs: #{obs}  params:#{params}"
    return 'selected' if obs.id == params[:id].to_i
  end

end


