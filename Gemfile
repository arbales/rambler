# A sample Gemfile
source "http://rubygems.org"

gem "rake"
gem "async_sinatra"
gem "sinatra"
gem 'sinatra-contrib', require: 'sinatra/reloader'
gem "active_support", require: ['active_support/core_ext', 'active_support/inflector']

gem "rabl"
gem "builder"
gem "haml"
gem 'sass', :require => 'sass'
gem 'compass'
gem "sprockets", '~> 2.4.0'
gem "sprockets-sass"
gem 'sprockets-commonjs', require: 'sprockets/commonjs'
gem 'alphasights-sinatra-sprockets', require: 'sinatra/sprockets'

gem "i18n"
gem "ohm"
gem "ohm-contrib"

group :development do
  gem "libv8"
  gem 'coffee-script-source', '1.1.3'
  gem 'coffee-script', :require => "coffee_script"
  gem 'uglifier'
  gem "closure"
  gem 'yui-compressor', :require => "yui/compressor"
  gem 'therubyracer'
end

# Users

gem "omniauth"
# gem 'omniauth-facebook'
gem 'omniauth-identity'
gem 'bcrypt-ruby', require: 'bcrypt'

gem 'faye'
gem 'foreman'
gem "unicorn"

group :push do
  gem 'thin'
end

group :test, :development do
  gem 'guard-sprockets2' # , path: '../guard-sprockets2'
  gem 'rb-fsevent'
  gem 'growl_notify'
end
