__locale = 'en'

i18n =
  en:
    'channel.cantSign': "Can't sign outgoing message for channel: {{channel}}"

  pirate:
    'channel.cantSign': "Yaar! You can't be sendin' messages on {{channel}}}"

_.templateSettings =
  interpolate: /\{\{(.+?)\}\}/g

window.t = (id, vars = {}) ->
  template = i18n[__locale][id] or i18n['en'][id] or "(?) #{id}"
  _.template(template, vars)

