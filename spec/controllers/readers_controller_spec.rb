require 'spec_helper'
require 'factory_girl'

RSpec.describe Admin::ReadersController, :type => :controller do
  let(:admin){ create(:reader, is_reader2: true ) }

	before(:each) do
    login admin
	end

  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

end