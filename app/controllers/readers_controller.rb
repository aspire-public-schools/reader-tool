class ReadersController < ApplicationController
	# include SessionHelper

	def index
		@reader = Reader.new
	end
end


