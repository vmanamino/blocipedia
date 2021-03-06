source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# in production use postgre for active record
group :production do
  gem 'pg'
  gem 'rails_12factor'
end
# in dev use sqlite3 for active record
group :development do
  gem 'sqlite3'
end

group :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'capybara', '~> 2.3.0'
  gem 'stripe-ruby-mock', '~> 2.1.1', require: 'stripe_mock'
  gem 'shoulda-matchers', '~> 3.0.0.alpha'
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # find style convention errors
  gem 'rubocop', require: false
end

gem 'figaro', '1.0'
# bootstrap style
gem 'bootstrap-sass'
gem 'faker'
# user authentication
gem 'devise'
# use FactoryGirls for rspec tests
gem 'factory_girl_rails', '~> 4.0'
# more precise logs for tests
gem 'whiny_validation'
# haml for cleaner mark up
gem 'haml', '~> 4.0.5'
# pretty URLs via friendly_id
gem 'friendly_id', '~> 5.1.0'
# pundit for authorization
gem 'pundit'
# test code coverage
gem 'simplecov', require: false, group: :test
# stripe to handle payments
gem 'stripe'
# markdown gem
gem 'redcarpet'
