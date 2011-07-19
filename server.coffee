sys = require 'sys'
http = require 'http'  
express = require 'express'    
env = process.env
require 'express-mongoose'
live = require 'faye'         

# For Dataz
db = require('models').db

# For auth
mongooseAuth = require('models').mongooseAuth


# App Setup

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
    console.log message
    if message?.data?.text
      Post = db.model 'Post'
      post = new Post({body: message.data.text, channel: message.channel})
      post.save()
    callback(message)
}

live.addExtension persister

module.exports = app = express.createServer(
  express.bodyParser()
  express.cookieParser()
  express.session({secret: 'dgdfgsdf1234'})
  mongooseAuth.middleware()
)

app.configure ->
  app.set 'views', __dirname + '/views'
  app.use express.methodOverride()
  app.use(express.favicon())
  app.use express.logger()
  app.use express.compiler
    src: __dirname + '/client', 
    dest: __dirname + '/public',
    enable: ['coffeescript'] # Renders less and coffee files inside app/ to public/

  app.use(express.static(__dirname + '/public'));
  
app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true }) 

app.configure 'production', ->
  app.use express.errorHandler()


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
    console.log req.user
    res.render 'index.jade'
      layout: 'app.jade'
      locals:
          title: 'Rambler'
  else
    res.redirect '/login'

mongooseAuth.helpExpress app
app.listen(3000)
live.attach(app)