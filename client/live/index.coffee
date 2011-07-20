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
      message.data.username = "arbales"
    callback message