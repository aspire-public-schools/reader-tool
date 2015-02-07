source 'https://rubygems.org'

ruby "1.9.3"

gem 'rails', '~> 3.2.14'
gem 'jquery-rails'
gem 'simple_form'

gem 'pg'
gem 'rails_12factor'

gem 'unicorn'
gem 'rack-timeout'

gem 'humanize'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'debugger'
  gem 'quiet_assets'
  gem 'sextant'
end

group :test do
  # gem 'capybara'
  # gem 'selenium-webdriver'
  gem 'shoulda-matchers'
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

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails'
  gem "less-rails"
  gem "therubyracer"
end
