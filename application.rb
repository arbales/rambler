Bundler.require
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/async'
require 'digest'
require 'rabl'


SCOPE = 'email,read_stream'

require './models/ohm'

module Rambler
  class Application < Sinatra::Base
    register Sinatra::Async

    use Rack::Session::Cookie

    Rabl.register!

    use OmniAuth::Builder do
      # provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], :scope => SCOPE
      provider :identity, fields: [:email], model: User
    end

    set :root, File.dirname(__FILE__)
    set :logging, true
    set :public_path, './public'
    set :views, settings.root + '/web/views'

    configure :development do
      register Sinatra::Reloader
      also_reload './models/user.rb'
    end

    get '/' do
      haml :index
    end

    get '/register' do
      haml :user
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
    post '/users/:id/signatures' do
      if user = User[params[:id]]
        content_type :json

        channel = Channel.find_or_create_by_path params[:channel]

        # Create a new signature for the specified channel.
        expires = 1.hour.from_now.to_s
        hash = Digest::SHA2.hexdigest [user.id, user.name, params[:channel], expires, true, ENV['RAMBLER_SALT']].join('-')

        signature = Signature.create(channel: channel, user: user, expires_at: expires, token: hash, read_only: false)
        user.signatures.add signature
        @signatures = user.signatures

        render :rabl, :signatures, format: 'json'
      end
    end

    get '/users/:id/signatures' do
      if user = User[params[:id]]
        @signatures = user.signatures
        render :rabl, :signatures, format: 'json'
      end
    end

    get '/channels/:id' do
      @channel = Channel[params[:id]]
      render :rabl, :channel, format: 'json'
    end

    # POST /channels/1/users {user: 1}
    post '/channels/:channel_id/users' do
      user = User[params[:user]]
    end

    %w(get post).each do |method|
      send(method, "/auth/:provider/callback") do
        auth = env['omniauth.auth'] # => OmniAuth::AuthHash
        session['user'] = auth['info']['uid']
      end
    end

  end
end
