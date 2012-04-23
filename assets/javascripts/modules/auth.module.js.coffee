module.exports = ClientAuthentication =
  outgoing: (message, callback) ->
    if message.channel isnt '/meta/subscribe'
      return callback message

    message.ext ?= {}
    if signature = Rambler.tokens.forChannel message.channel
      message.ext.signature = signature
    else
      message.error = t 'channel.cantSign', channel: message.channel

    # Set the auth token
    callback(message)
