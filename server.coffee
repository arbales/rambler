sys = require 'sys'
http = require 'http'  
express = require 'express'    
env = process.env
require 'express-mongoose'
live = require 'faye'  
request = require 'request'       

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
  
persister = {
  incoming: (message, callback) ->
    console.log "PS"
    console.log message
    if message?.data?.text
      Post = db.model 'Post'                                                                                      
      d = new Date()
      post = new Post({text: message.data.text, channel: message.channel, username: message.data.username, date: d})
      post.save()
    callback(message)
}  

live.addExtension persister      

#
# Express
#

module.exports = app = express.createServer(
  express.bodyParser()
  express.cookieParser()
  express.session({secret: 'dgdfgsdf1234'})
  goose.middleware()
)

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
  
  
## Routes                                   

app.get '/hello', (req, res) ->
  if not req.loggedIn
    res.redirect '/auth/github'
  else
   

app.get '/reset', (req, res) ->
  Post = db.model 'Post'
  Post.remove()

app.get '/:channel/posts', (req, res) ->
  Post = db.model 'Post'
  res.send(Post.find({channel: "/#{req.params.channel}"},(->)))

  
app.get '/posts', (req, res) ->
  Post = db.model 'Post'
  res.send(Post.find({},(->)))

app.get '/login', (req, res) ->
  res.render 'login.jade'
    locals:
      title: 'Login to Rambler'

app.get '/', (req, res) ->
  if req.loggedIn
    res.render 'index.jade'
      layout: 'app.jade'
      locals:
          title: 'Rambler'
  else
    res.redirect '/auth/github' 
    
# Startup    

goose.helpExpress app
app.listen(3000)
live.attach(app)