hash = require 'node_hash'

pushToken = (token) ->
  hash.sha256 token, "salt"

module.exports = (context) ->
  app = context.app
  db = context.db

  app.get '/hello', (req, res) ->
    if not req.loggedIn
      res.redirect '/auth/github'
    else
   
  # DANGER: Remove
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
              
  chat = (req, res) ->
    if req.session.returnTo
      target = req.session.returnTo
      req.session.returnTo = undefined
      return res.redirect target

    if req.loggedIn
      # console.log req
      req.session.pushToken = pushToken req.user.fb.accessToken

      # console.log req.s

      res.render 'index.jade'
        layout: 'app.jade'
        locals:
          pushToken: req.session.pushToken
          title: 'Rambler'
    else                     
      req.session.returnTo = req.url
      res.redirect '/auth/facebook'
      
  app.get '/', chat
  app.get '/room/:name', chat