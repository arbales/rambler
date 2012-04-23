# $:.unshift File.expand_path("../", __FILE__)
require 'bundler'
Bundler.require ENV['RACK_ENV'] || :development


require "./application"
require './assets'

use Faye::RackAdapter, :mount      => '/push',
                       :timeout    => 25
#                       :extensions => [MyExtension.new]

map '/assets' do
  Rambler::Application.helpers Sinatra::Sprockets::Helpers
  run Sinatra::Sprockets.environment
end

map '/' do
  Rambler::Application.set :sprockets, Sinatra::Sprockets.environment
  run Rambler::Application
end


