source 'https://rubygems.org'

ruby "2.1.5"

gem 'rails', '~> 3.2.21'
# gem 'rails', github: 'rails/rails', branch: '3-2-stable'

gem 'jquery-rails'
gem 'simple_form'

gem 'pg'
gem 'rails_12factor'

gem 'unicorn'
gem 'rack-timeout'

gem 'humanize'

gem 'net-sftp'

gem 'bcrypt-ruby', '~> 3.0.0' 

group :assets do
  gem 'sass',   '< 3.3.0' # prevent heroku assets compilation error
  gem 'sass-rails',   '< 3.3.0'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails'
  gem "less-rails"
  gem "therubyracer"
end

group :development do
  # gem 'pry'
  gem 'better_errors'
  gem 'binding_of_caller'
  # gem 'pry-debugger'
  gem 'quiet_assets'
  gem 'sextant'
  # gem 'lol_dba'

  ## ?? these are needed for rails console.. weird mismatch between ruby 2 and rails 3?
  gem 'minitest'
  gem 'test-unit'
end

group :test do
  # gem 'capybara'
  # gem 'selenium-webdriver'
  # gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'database_cleaner'
end

group :development, :test do
  gem 'rspec-rails'
  gem "factory_girl_rails", "~> 4.0"
  gem "rack_session_access"
  gem 'populator'
  gem 'dotenv'
  gem 'railroady'
end

group :test do
  gem 'faker'
end
