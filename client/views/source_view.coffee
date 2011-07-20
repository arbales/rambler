class Rambler.Views.SourceView extends Rambler.Views.Base

  events:
    "click .hide": "hide"
    "click a": "navigate"

  initialize: (opts) ->
    @options = _.defaults opts,
      current_channel: "Unknown Channel"
      
    _.bindAll @, "hide"
  render: ->
    @$('ul').html "<li><a href='room/#{@options.current_channel}'>#{@options.current_channel}<a></li>"
    @
  hide: ->               
    $(@partner_el).toggleClass "expanded"
    $(@el).toggleClass "hidden"
  
  navigate: (e) ->
    e.preventDefault()
    Rambler.app.navigate($(e.currentTarget).attr('href'), true);
  