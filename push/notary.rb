module Notary
  def verify(channel, signature)
    hash = Digest::SHA2.hexdigest [signature.userid, signature.name, signature.channel, signature.expires, signature.read_only, ENV['RAMBLER_SALT']].join('-')
    hash == signature.token
  end
  def incoming(message, callback)
    channel = message['channel']
    signature = message['ext'] && message['ext']['signature']
    unless verified = verify(channel, signature)
      message['error'] = ['Signature not valid for channel.', 403]
    end
    message(callback)
  end
end
