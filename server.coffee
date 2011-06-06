sys = require 'sys'
http = require 'http'  
express = require 'express'    
env = process.env
# The streaming system
live = require 'faye'         

# For Dataz
mongoose = require 'mongoose'
Schema = mongoose.Schema
mongoose.connect('mongodb://localhost/rambler2_development')

# The Auth library
everyauth = require 'everyauth' 

# App Setup

module.exports = app = express.createServer()      
live = new live.NodeAdapter {
  mount:    '/live',
  timeout:  45     
  engine:
    type:   'redis'
    host:   'localhost'
    port:   '6379'
}

app.configure ->
  app.set 'views', __dirname + '/views'
  app.use express.methodOverride()
  app.use express.logger()
  app.use express.bodyParser()
  app.use express.compiler(
    src: __dirname + '/client', 
    dest: __dirname + '/public',
    enable: ['coffeescript'] # Renders less and coffee files inside app/ to public/
  )
  app.use(express.static(__dirname + '/public'));
  app.use app.router
  app.use everyauth.middleware()
  
app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true }) 

app.configure 'production', ->
  app.use express.errorHandler()



# Connect Everyauth to the express application
# everyauth.facebook
#   .myHostname("http://localhost:3000")
#   .appId(env.FACEBOOK_APP_ID)
#   .appSecret(env.FACEBOOK_APP_SECRET)
#   .findOrCreateUser (session, token, meta) =>
#     sys.puts session
#     
# everyauth.debug = true
# everyauth.helpExpress app




  


app.get '/', (req, res) ->
  res.render 'index.jade', {
    locals: {
        title: 'Rambler'
    }
  }

app.listen(3000)
live.attach(app)