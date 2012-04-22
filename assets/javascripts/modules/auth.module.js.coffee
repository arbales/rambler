module.exports = ClientAuthentication =
  outgoing: (message, callback) ->    
    #if message.channel isnt '/meta/subscribe'
    #  return callback message

    # Add ext field if it's not present
    message.ext = {} unless message.ext

    # Set the auth token
    message.ext.pushToken = Rambler.Bootstrap.pushToken
    message.ext.userName = Rambler.Bootstrap.FacebookUserID
    callback(message)
