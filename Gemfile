source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
# Use SCSS for stylesheets
# gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
# gem 'jquery-rails'

#gem 'jbuilder', '~> 2.0'

gem 'active_model_serializers'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'omniauth'
gem 'omniauth-facebook'#, '1.4.0'



group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry'
  gem 'pry-nav'
  gem 'hirb'
  gem 'awesome_print'
  gem 'rspec-rails'
  gem 'spring-commands-rspec'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers', require: false
  gem 'spring'
end

group :test do
  #gem 'capybara'
  gem 'database_cleaner'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'quiet_assets'
  gem "better_errors"
  gem "binding_of_caller" #if you use better_errors
end

