Rambler = {
  Live: {}
}
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
    console.log message
    if message.data and not message.channel.match /\/meta\//
      message.data.username = "placeholder"
    callback message
    
live.addExtension Rambler.Live.Persister      
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

require('routes.coffee')({app: app, db: db})
    
# Startup    

goose.helpExpress app
app.listen(3000)
live.attach(app)