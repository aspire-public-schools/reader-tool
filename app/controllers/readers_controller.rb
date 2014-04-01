class ReadersController < ApplicationController

	def index
    redirect_to observations_path if current_user
		@reader = Reader.new
	end
end

