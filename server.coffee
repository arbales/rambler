sys = require 'sys'
http = require 'http'  
express = require 'express'    

live = require 'faye'         

mongoose = require('mongoose')
Schema = mongoose.Schema

mongoose.connect('mongodb://localhost/rambler2_development')

app = express.createServer()      

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
  # app.use express.bodyDecoder()
  app.use express.methodOverride()
  app.use express.logger()
  app.use express.bodyParser()
  app.use express.compiler(
    src: __dirname + '/app', 
    dest: __dirname + '/public',
    enable: ['sass', 'coffeescript'] # Renders less and coffee files inside app/ to public/
  )
  app.use(express.static(__dirname + '/public'));
  app.use app.router
  # app.use express.staticProvider(__dirname + '/public')      
  
app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true }) 


app.configure 'production', ->
  app.use express.errorHandler()
  
  


app.get '/', (req, res) ->
  res.render 'index.jade', {
    locals: {
        title: 'Express-Juggernaut demo'
    }
  }

app.listen(3000)
live.attach(app)