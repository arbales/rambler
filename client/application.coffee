this.Rambler = Rambler = {
  Models: {}
  Views: {}
  Resources: {}
}   

Rambler.client = new Faye.Client('/live') 

r = Rambler.Resources                           

class r.Channel
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
    
  
class r.Chat extends r.Channel
  name: "/chat"
  url: "/chat"

chat = new r.Chat()

#class Rambler.Views.Stream

Stream = Spine.Controller.create
  events:
    "submit #publisher": "send"

  init: ->
    @messages = @el.find('.messages')?[0]
    
  send: (event) ->
    target = $(event.currentTarget).find("input")
    value = target.val()
    @stream.send value
#    console.log $(@m
    d = new Date()
    $(@messages).append "<li>#{value}<p class='details'><a class='user' href='/href'>username</a> <time class='timeago' datetime='#{d.format('isoDateTime')}'></time></p></li>"
    $(@messages).prop("scrollTop", $(@messages).prop("scrollHeight"))
    $(@el).find('time').timeago();
    target.val ""
    false
    


$(document).ready ->
  stream = Stream.init
    el: $('#chat')
    stream: new r.Chat()
  # jQuery("time.timeago").timeago()