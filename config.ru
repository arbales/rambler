# $:.unshift File.expand_path("../", __FILE__)
require 'bundler'
Bundler.require
                                        
require 'faye'
require 'sinatra'
require 'haml'
require 'sprockets'
require 'sprockets-sass'
# require 'sprockets-helpers'
# require 'sprockets-commonjs'
require 'sass'
require 'compass'

require 'uglifier'
#require "yui/compressor"

require "./application"      

use Faye::RackAdapter, :mount      => '/push',
                       :timeout    => 25
#                       :extensions => [MyExtension.new]

                          
map '/assets' do
  run Sinatra::Sprockets.environment
end

map '/' do
  run Application
end

