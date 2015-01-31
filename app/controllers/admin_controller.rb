class AdminController < ApplicationController
  skip_before_filter :require_login

  http_basic_authenticate_with :name => "admin", :password => "password" # unless Rails.env.development?

end

