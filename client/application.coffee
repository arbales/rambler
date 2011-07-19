this.Rambler = Rambler = {
  Models: {}
  Views: {}
  Resources: {}
}   

Rambler.client = new Faye.Client('/live') 

r = Rambler.Resources 

Authenticater =
  outgoing: (message, callback) ->    
    console.log message
    if message.data and not message.channel.match /\/meta\//
      message.data.username = "arbales"
    callback message

Rambler.client.addExtension Authenticater    

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
      console.log message
      @stream.add message

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
    
SourceView = Spine.Controller.create
  events:
    "click .hide": "hide" 
          
  hide: ->               
    $(@partner_el).toggleClass "expanded"
    $(@el).toggleClass "hidden"    
        
    
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
          @add s
        if data.length < 1
          @add {text: "There are no messages in this room.", username: "Rambler", style: 'initial'}
    
  send: (event) ->
    target = $(event.currentTarget).find("input")
    value = target.val()
    @channel.send value
    target.val ""
    false
    
  add: (message) ->
    # date = do (message)
    #   if message.date and _date = Date.parse(message.date)
    #     _date if date
    date = if message.date? then message.date else (new Date()).toJSON()
    msg = message?.text?.replace /(https?:\/\/[^\s]+)/g, (url) ->
      "<a href='#{url}'>#{url}</a>"
    el = $("<li>#{msg}<p class='details'><a class='user' href='/href'>#{message.username}</a> <time class='timeago' datetime='#{date}'></time></p></li>")  
    row = $(@messages).append el   
    el.prev().toggleClass('previous')                          
    if message.style then el.addClass message.style
    $(el).find('time').timeago()     
    $(el).embedly
      maxHeight: 300,
      wmode: 'transparent',
      method: 'replace'
    $(@messages).prop("scrollTop", $(@messages).prop("scrollHeight"))
    false


$(document).ready ->
  stream = Stream.init
    el: $('#chat')
    channel: new r.Chat()  
  sidebar = SourceView.init
    el: $('#source_view')
    partner_el: $('#chat')
    
  stream.pull()
