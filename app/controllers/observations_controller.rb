class ObservationsController < ApplicationController
  include SessionHelper

	def index
    # p current_user
		@reader = current_user
    @domain = Domain.all
    @evidence = Evidence.all
  end
end

