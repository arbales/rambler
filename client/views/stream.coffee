class Rambler.Views.Stream extends Rambler.Views.Base

  events:
    "submit #publisher": "send"

  initialize: (options) ->
    @channel = options.channel
    @messages = @el.find('.messages')?[0]
    @channel.stream = @

  pull: ->
    $.ajax
      url: "/#{@channel.name}/posts"
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