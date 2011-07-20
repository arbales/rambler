module.exports = (context) ->
  app = context.app
  db = context.db

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