class SessionsController < ApplicationController
   include SessionHelper

   def create
      reader = Reader.find_by_email(params[:reader][:email])
      if reader
         session[:current_reader_id] = reader.id 
         redirect_to observations_path
      else
         redirect_to root_path
      end
   end
end
   