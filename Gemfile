source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'active_model_serializers'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# RailsAPI
gem 'rails-api'
gem 'rack-cors', :require => 'rack/cors'

# ApiPie por API documentation
gem 'apipie-rails'

gem 'kaminari'                      # Pagination
gem 'searchlight'

gem 'js-routes'
gem "i18n-js", ">= 3.0.0.rc8" 

gem 'thin'                          # Server

gem "cocoon"

gem 'devise' #Login
gem 'devise_token_auth'
gem 'pundit'
gem 'administrate', '0.1.2'

gem 'simple_form'

gem 'haml'
gem "haml-rails", "~> 0.9"
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'sidekiq'
gem 'sidekiq-status'
gem 'draper'

gem 'paper_trail', '~> 4.0.0'

# logic delete
gem "paranoia", "~> 2.0"

#PreMailer
gem 'premailer-rails'

#Bourbon
gem 'bourbon', '~> 4.0'

#Bootstrap
gem 'bootstrap-sass', '~> 3.3.5'

#Font Awesome
gem "font-awesome-rails"

#Tree
gem 'ancestry'

# File uploading and image processing
gem "mini_magick"
gem "carrierwave"
gem "carrierwave-base64"

group :development, :test do
  #Manage ENV variables
  gem 'dotenv-rails'
  # Testing
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'shoulda-matchers', '~> 3.0', require: false 
  gem 'database_cleaner', '~> 1.5'
  gem 'capybara'
  gem 'faker'
  
  #Doc
  gem 'annotate'
  gem 'yard'
  #Email utilities
  gem 'letter_opener'
  #Debug and Dev
  gem 'spring'
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'
  gem 'web-console', '~> 2.0'
  gem "better_errors" #better error screen
  gem "binding_of_caller" #for better error best support
  gem 'pry-rescue' #with bundle exec rescue rails server init rescue and open pry on wach exception not rescued. also rescue rspec
  gem 'hirb' #tabular active record data. view initialize/hirb.rb
  gem 'pry-doc' #more power with show-source and show-doc pry commands
  gem 'pry-toys' #example Hash.toy(20)
  gem 'pry-state' #session pry state - variables on screen alternative pry-inline
end

group :production do
  gem 'foreman'
  gem 'stackmint', git: "git@github.com:chanozignego/stackmint.git"
  gem 'puma'
  gem 'recipient_interceptor' #for staging environment - SET ENV['STAGING'] for to use
end