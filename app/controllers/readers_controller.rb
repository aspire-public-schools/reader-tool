class ReadersController < ApplicationController

	def index
		@reader = Reader.new
	end
end


