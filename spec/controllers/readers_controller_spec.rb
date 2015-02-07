require 'spec_helper'
require 'factory_girl'

describe Admin::ReadersController do
	before(:each) do
		@reader = build(:reader)
	end

  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end
end