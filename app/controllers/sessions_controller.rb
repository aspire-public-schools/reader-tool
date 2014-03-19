class SessionsController < ApplicationController
   include SessionHelper

   def create
      params_email_downcase = params[:reader][:email].downcase
      reader = Reader.find_by_email(params_email_downcase)
      if reader
         session[:current_reader_id] = reader.id
         redirect_to observations_path
      else
         redirect_to root_path, flash: {error: "Godzilla didn't like your e-mail"}
      end
   end

   def destroy
      logout
      redirect_to root_path
   end
end
