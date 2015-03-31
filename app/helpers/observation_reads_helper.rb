module ObservationReadsHelper

  def print_cert value
    @dropdown.find{|d| d.last == value }.try(:first)
  end

  def highlight_if_showing obs
    # p "obs: #{obs}  params:#{params}"
    return 'selected' if obs.id == params[:id].to_i
  end

end


