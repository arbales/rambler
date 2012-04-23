class Rambler.Token extends Rambler.Model

class Rambler.TokenList extends Rambler.Collection
  url: '/users/9/signatures'
  mode: Rambler.token
  forChannel: (name) ->
    name = if name[0] isnt '/' then '/' + name else name
    tokens = @where(channel_path: name)
    tokens?[0]
    # Nothing

