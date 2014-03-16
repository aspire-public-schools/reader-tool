class ReadersController < ApplicationController

  #page where you show all of them
	def index
    redirect_to observations_path if current_user
		@reader = Reader.new
  #just needs to be tied to a reader
  #So that it ties to your database so it ties model
	end
end

