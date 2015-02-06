class ApplicationController < ActionController::Base
  
  protect_from_forgery
  include SessionHelper

  before_filter :require_login

  protected

  def require_login
    redirect_to login_path unless signed_in?
  end

end
