class Rambler.Views.SourceView extends Rambler.Views.Base

  events:
    "click .hide": "hide" 

  initialize: ->
    _.bindAll @, "hide"
    
  hide: ->               
    $(@partner_el).toggleClass "expanded"
    $(@el).toggleClass "hidden"