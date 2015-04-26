module ObservationReadsHelper

  def print_cert value
    @dropdown ||= ObservationRead::STATES.map.with_index{|state,idx| [state, idx+1]}
    @dropdown.find{|d| d.last == value }.try(:first) || 'unscored'
  end

  def highlight_if_showing obs
    return 'selected' if obs.id == params[:id].to_i
  end

end


