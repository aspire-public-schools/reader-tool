source 'https://rubygems.org'

ruby "2.2.0"

gem 'rails', '~> 3.2.14'
gem 'jquery-rails'
gem 'simple_form'

gem 'pg'
gem 'rails_12factor'

gem 'unicorn'
gem 'rack-timeout'

gem 'humanize'

gem 'net-sftp'

group :development do
  gem 'pry'
  gem 'better_errors'
  gem 'binding_of_caller'
  # gem 'pry-debugger'
  gem 'quiet_assets'
  gem 'sextant'
  gem 'lol_dba'
end

group :test do
  # gem 'capybara'
  # gem 'selenium-webdriver'
  # gem 'shoulda-matchers'
  gem 'simplecov'
  # gem 'database_cleaner'
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

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails'
  gem "less-rails"
  gem "therubyracer"
end
