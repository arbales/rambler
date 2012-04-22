Bundler.require
require 'sinatra/base'
require 'sinatra/reloader'  
require 'sinatra/async'
require 'digest' 
require 'rabl'


SCOPE = 'email,read_stream'      

require './models/ohm'

module Notary                    
  def verify(channel, signature)                      
    hash = Digest::SHA2.hexdigest [signature.userid, signature.name, signature.channel, signature.expires, signature.read_only, ENV['RAMBLER_SALT']].join('-')
    hash == signature.token
  end
  def incoming(message, callback)
    channel = message['channel']
    signature = message['ext'] && message['ext']['signature']
    unless verified = verify(channel, signature)
      message['error'] = ['Signature not valid for channel.', 403]
    end    
    message(callback)       
  end
end

class Application < Sinatra::Base     
  register Sinatra::Async  
  
  use Rack::Session::Cookie           
  
  Rabl.register!
    
  use OmniAuth::Builder do
    provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], :scope => SCOPE
  end
  
  set :root, File.dirname(__FILE__)
  set :logging, true   
  set :public_path, './public'

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    haml :index
  end        
   
  post '/user' do
    user = User.create :name => params[:name]
    user.id.to_s
  end                                     
  
  get '/users/:id' do
    content_type :json
    if @user = User[params[:id]]
      render :rabl, :user, format: 'json'
    else
      not_found
    end
  end
                   
  # POST /users/1/signatures?channel=/chat
  # post '/users/:id/signatures' do
  #   if user = User[params[:id]]                                          
  #     content_type :json
  # 
  #     # Create a new signature for the specified channel.
  #     expires = 1.hour.from_now.to_s      
  #     hash = Digest::SHA2.hexdigest [user.id, user.name, params[:channel], expires, true, ENV['RAMBLER_SALT']].join('-')
  #     signature = Signature.create(channel_name: params[:channel], expires_at: expires, token: hash, read_only: false)
  #     user.signatures.add signature
  #     
  #     render :rabl, :signatures, format: 'json'
  #   end
  # end  
                                   
  # POST /channels/1/users {user: 1}
  post '/channels/:channel_id/users' do
    user = User[params[:user]]     
    
  end
  
  %w(get post).each do |method|
    send(method, "/auth/:provider/callback") do
      puts env['omniauth.auth'] # => OmniAuth::AuthHash
    end
  end   

end



Sinatra::Sprockets.configure do |config|            
  ['stylesheets', 'javascripts', 'images'].each do |dir|
    config.append_path(File.join('assets', dir))
  end              
  config.app = Application
  config.prefix = "/assets" 
  config.compile = true
  config.digest = true
  config.append_path 'vendor/assets/javascripts'
  config.js_compressor = Uglifier.new(:copyright => false)
  config.precompile = [ /\w+\.(?!js|css).+/, /application.(css|js)$/ ]
                                                     
  Application.helpers Sinatra::Sprockets::Helpers  
end

Application.set :sprockets, Sinatra::Sprockets.environment