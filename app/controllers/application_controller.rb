class ApplicationController < ActionController::Base
  
  protect_from_forgery
  include SessionHelper

  before_filter :require_login

  def staging?
    Rails.env.development? || !!ENV['STAGING']
  end

  helper_method :staging?

  protected

  def require_login
    store_location
    redirect_to login_path unless signed_in?
  end

end
