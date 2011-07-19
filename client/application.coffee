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
    
  receive: (message) =>
    if @stream
      @stream.add message.text

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

Post = Spine.Model.setup "Post", ['body']
#Post.extend Spine.Model.Ajax
#Post.fetch()

# class Post extends Backbone.Model
#   defaults: {
#     body: ""
#   }
#
# class Posts extends Backbone.Collection
#   url: ->
#     "#{@channel.url}/posts"

Stream = Spine.Controller.create
  events:
    "submit #publisher": "send"

  init: ->
    @messages = @el.find('.messages')?[0]
    @channel.stream = @

  pull: ->
    $.ajax
      url: '/chat/posts'
      success: (data) =>
        _.each data, (s) =>
          @add s.body
    
  send: (event) ->
    target = $(event.currentTarget).find("input")
    value = target.val()
    @channel.send value
    d = new Date()
    target.val ""
    false
    
  add: (value) ->
    $(@messages).append "<li>#{value}<p class='details'><a class='user' href='/href'>username</a> <time class='timeago' datetime='#{d.format('isoDateTime')}'></time></p></li>"
    $(@messages).prop("scrollTop", $(@messages).prop("scrollHeight"))
    $(@el).find('time').timeago()
    false


$(document).ready ->
  stream = Stream.init
    el: $('#chat')
    channel: new r.Chat()
  stream.pull()
