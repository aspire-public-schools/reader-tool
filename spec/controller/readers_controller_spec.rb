require 'spec_helper'
require 'factory_girl'

describe ReadersController do
	before(:each) do
		@reader = build(:reader)
	end

	it "#index" do
		get :index
		response.status.should eq(200)
	end
end