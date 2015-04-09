class SessionsController < ApplicationController

  skip_before_filter :require_login

  def new  # login form
    redirect_to observation_reads_path if signed_in?
  end

  def create
    reader = Reader.find_by_email(params[:reader][:email])
    if reader && (staging? && !reader.password_digest?) || reader.authenticate(params[:password])
      session[:current_reader_id] = reader.id
      redirect_to return_to_location || observation_reads_path
    else
      redirect_to login_path, flash: {error: "Invalid credentials!"}
    end
  end
  
  def destroy
    logout
    redirect_to login_path, flash: {notice: "You are now logged out"}
  end
end
