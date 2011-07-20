class Rambler.Models.Channel
  intitialize: ->  
    _.bindAll ['receive', 'subscribed', 'failure']
    @subscription = Rambler.client.subscribe @name, @receive
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
    Rambler.client.publish @name, {text: text}
  cancel: ->           
    @subscription.cancel()