# Namespaces

window.Rambler = Rambler = {
  Models: {}
  Views: {}
  Resources: {}   
  Live: {}
}              

Rambler.Models = require 'models'
require 'views'             

Rambler.client = new Faye.Client('/live')  
  
#Rambler.client.addExtension Rambler.Live.Persister
#Rambler.client.addExtension Rambler.Live.Authenticater    

class Rambler.Workspace extends Backbone.Router
  
  routes:
    "":             "chat"
    "room/:name":   "room"
                                                       
  chat: ->
    @room('chat')
    
  room: (name) ->                                
    # Need to cleanup before doing this a second time?
    @stream = new Rambler.Views.Stream
      el: $('#chat')
      channel: new Rambler.Models.Channel
        name: name,
        url: "/#{name}"
        
    @sidebar = new Rambler.Views.SourceView
      current_channel: name
      el: $('#source_view')
      partner_el: $('#chat')
    @sidebar.render()
    @stream.pull()


$ ->
  Rambler.app = new Rambler.Workspace()
  Backbone.history.start {pushState: true}

