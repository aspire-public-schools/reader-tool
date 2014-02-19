class ObservationsController < ApplicationController
  include SessionHelper

	def index
    # p current_user
		@reader = current_user
    @domain = Domain.all
    @indicator = Indicator.all
  end
end

