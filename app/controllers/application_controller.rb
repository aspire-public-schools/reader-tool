class ApplicationController < ActionController::Base
  before_filter :require_login
  
  protect_from_forgery
  include SessionHelper
end
