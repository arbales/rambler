this.Rambler = Rambler = {
  Models: {}
}   

Rambler.client = new Faye.Client('/live') 

m = Rambler.Models                           

class m.Channel
  constructor: (name) ->  
    @name ?= name
    _.bindAll ['receive', 'subscribed', 'failure']
    @subscription = Rambler.client.subscribe @name, @receive
    @subscription.callback @subscribed
    @subscription.errback @failure 
    @
    
  receive: (message) ->
    console.log message
     
  subscribed: ->
    console.log "Subscribed #{@name}"
    
  failure: (error) ->
    console.warn error    

  send: (text) ->   
    Rambler.client.publish @name, {text: text}
  cancel: ->           
    @subscription.cancel()
    
  
class m.Chat extends m.Channel
  name: "/chat"
  url: "/chat"

chat = new m.Chat()

$(document).ready ->
  $('#publisher').submit (event) ->
    chat.send $('#publisher input').val()
    $('#publisher input').val ""
    false