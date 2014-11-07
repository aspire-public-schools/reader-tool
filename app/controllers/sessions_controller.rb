class SessionsController < ApplicationController
  include SessionHelper

  if Rails.env.development?
    def create
      if reader = Reader.find_by_employee_number(params[:eid])
        session[:current_reader_id] = reader.id
        redirect_to observations_path
      else
        redirect_to root_path, flash: {error: "Reader not found!"}
      end
    end
  end
  
  def destroy
    logout
    redirect_to "https://aspire.onelogin.com"
  end
end
