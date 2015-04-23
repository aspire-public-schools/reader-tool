class SessionsController < ApplicationController

  skip_before_filter :require_login

  def new  # login form
    redirect_to observation_reads_path if signed_in?
  end

  def create
    redirect_invalid and return unless credentials_present?
    reader = Reader.find_by_email(params[:reader][:email])
    if reader && reader.authenticate(params[:reader][:password])
      login reader
      redirect_to return_to_location || observation_reads_path
    else
      redirect_invalid
    end
  end
  
  def destroy
    logout
    redirect_to login_path, flash: {notice: "You are now logged out"}
  end

  private

  def redirect_invalid
    redirect_to login_path, flash: {error: "Invalid credentials!"}
  end


  def credentials_present?
    params[:reader][:email].present? && params[:reader][:password].present?
  end

end
