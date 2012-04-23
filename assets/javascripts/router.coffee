auth = Rambler.auth = require 'modules/auth'
R = Rambler

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

R.app = new Rambler.Workspace
R.tokens = new Rambler.TokenList

R.app.bind 'tokens:ready', ->
  Rambler.client = new Faye.Client('/push')
  Rambler.client.addExtension auth
  Backbone.history.start {pushState: true}

$ ->
  R.tokens.fetch
    success: ->
      Rambler.app.trigger 'tokens:ready'

    error: ->
      Rambler.app.trigger 'tokens:failure'

