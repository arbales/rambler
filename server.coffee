Rambler =
  Live: {}
  config:
    port: 5000

sys = require 'sys'
http = require 'http'  
express = require 'express'    
env = process.env
require 'express-mongoose'
live = require 'faye'  
request = require 'request' 
stitch = require 'stitch'

# For Dataz
db = require('models').db

# Load authentication
goose = require('models').mongooseAuth
hash = require 'node_hash'



##
## Live
##

live = new live.NodeAdapter {
  mount:    '/live',
  timeout:  45     
  engine:
    type:   'redis'
    host:   'localhost'
    port:   '6379'
    namespace:  '/rambler'
}
User = db.model 'User'
  
Rambler.Live.Persister =
  incoming: (message, callback) ->
    if message?.data?.text
      Post = db.model 'Post'                                                                                      
      d = new Date()
      post = new Post({text: message.data.text, channel: message.channel, username: message.data.username, date: d})
      post.save()
    callback(message)

Rambler.Live.Authenticater =
  outgoing: (message, callback) ->    
    if message.data and not message.data.username and not message.channel.match /\/meta\//
      message.data.username = "placeholder"
    callback message

  incoming: (message, callback) ->
    if message.channel isnt '/meta/subscribe'
      callback message

    subscription = message.subscription
    messageToken = message.ext and message.ext.pushToken or

    if not messageToken
      message.error = "You must provide an authentication token."
      callback(message)

    else
      User.findOne {"facebook.id": message.ext.userName}, (error, user) ->
        if user and user?.fb?.accessToken
          userToken = hash.sha256 user.fb.accessToken, "salt"
          if userToken is messageToken
            # sick.
          else
            message.error = "Access token failure."
        else
          console.log "Fail"
          message.error = "Access token failure."
        callback(message)

# live.addExtension Rambler.Live.Persister
live.addExtension Rambler.Live.Authenticater                        


#
# Express
#

module.exports = app = express.createServer(
  express.bodyParser()
  express.cookieParser()
  express.session({secret: 'dgdfgsdf1234'})
  goose.middleware()
)

package = stitch.createPackage
  paths: ["#{__dirname}/client"]

## Configuration

app.configure ->
  app.set 'views', __dirname + '/views'
  app.use(express.static(__dirname + '/public'));
  app.use express.methodOverride()
  app.use express.logger()
  app.use express.compiler
    src: __dirname + '/client', 
    dest: __dirname + '/public',
    enable: ['coffeescript'] # Renders less and coffee files inside app/ to public/
  
app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true }) 

app.configure 'production', ->
  app.use express.errorHandler()       
  
app.get '/package.js', package.createServer()

require('routes.coffee')(
  app: app
  db: db
)
    
# Startup    

goose.helpExpress app
app.listen(Rambler.config.port)
live.attach(app)
console.log '''
                       _       .
.___    ___  , _ , _   \ ___   |     ___  .___
/   \  /   ` |' `|' `. |/   \  |   .'   ` /   \
|   ' |    | |   |   | |    `  |   |----' |   '
/     `.__/| /   '   / `___,' /\__ `.___, /
'''
console.log "\nRambler is now listening on port #{Rambler.config.port}"
console.log "\nYou're tuned to KRES, The Rambler Error Station...\n"
