class ReadersController < ApplicationController
	def index
		@reader = Reader.new
		p @reader
	end

end


