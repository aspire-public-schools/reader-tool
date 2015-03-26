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
      ENV["ORG_NAME_SHORT"]
    else
      ENV["ORG_NAME"]
    end
  end

  def logo_tag opts={}
    opts.reverse_merge! alt: organization_name
    image_tag "logos/#{organization_name(:short)}.png", opts
  end

  def print_check bool
    content_tag(:span,"&#10004;".html_safe, class: 'checkmark') if bool
  end

  def display_flash_messages
    render partial: "shared/flash_messages"
  end

  def print_percent val
    "%0.1f %" % (val.to_f*100)
  end

end
