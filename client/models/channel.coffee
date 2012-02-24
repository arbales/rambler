module.exports = class Channel

  constructor: (opts) ->
    @name = opts.name
    @url = opts.url      
    @stream = opts.stream
    console.log opts
    _.bindAll ['receive', 'subscribed', 'failure']
    @subscription = Rambler.client.subscribe @url, @receive
    @subscription.callback @subscribed
    @subscription.errback @failure 
    @
  
  receive: (message) =>
    if @stream     
      console.log message
      @stream.add message

  subscribed: ->
    # You're awesome.
  
  failure: (error) ->
    # You're a failure.
    console.warn error    

  send: (text) ->   
    Rambler.client.publish @url, {text: text}
  cancel: ->           
    @subscription.cancel()