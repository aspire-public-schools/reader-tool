module ApplicationHelper

  def bootstrap_class_for(error)
    case error
    when :success
      "alert-success"
    when :error
      "alert-error"
    when :alert
      "alert-block"
    when :notice
      "alert-info"
    else
      flash_type.to_s
    end
  end

  def organization_name kind=:long
    case kind
    when :short
      ENV["ORGANIZATION_NAME_SHORT"]
    else
      ENV["ORGANIZATION_NAME"]
    end
  end

  def print_check bool
    content_tag(:span,"&#10004;".html_safe, class: 'checkmark') if bool
  end

end
