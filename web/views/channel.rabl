object @channel
  attributes :path, :name

  child @channel.members do
    attribute :name
  end
