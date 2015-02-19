class SessionsController < ApplicationController

  skip_before_filter :require_login

  def new  # login form
    redirect_to observation_reads_path if signed_in?
  end

  def create
    params[:reader][:eid] = nil if params[:reader][:eid] == ""
    if reader = Reader.find_by_employee_number_and_email(params[:reader][:eid], params[:reader][:email])
      session[:current_reader_id] = reader.id
      redirect_to session.delete(:return_to) || observation_reads_path
    else
      redirect_to login_path, flash: {error: "Invalid credentials!"}
    end
  end
  
  def destroy
    logout
    redirect_to login_path, flash: {notice: "You are now logged out"}
  end
end
