require 'ohm/contrib/callbacks'

class Signature < Ohm::Model
  include Ohm::Callbacks
  attribute :token # TODO: Should I do this? Its not really required…
  attribute :expires_at
  attribute :read_only

  # References to other users.
  reference :user, User
  reference :channel, Channel

  after :save, :set_expires

protected

  def set_expires
    Ohm.redis.expire self.key, 10.minutes.to_i
  end

end

class Channel < Ohm::Model
  attribute :name
  attribute :path
  index :path

  set :members, User
  collection :signatures, Signature

  def self.create
    super

  end

  def self.find_or_create_by_path(path)
    unless channel = Channel.find(path: path) and channel.first
      self.create(path: path)
    else
      channel.first
    end
  end

  def add_member(member)
    self.members.add member
    self.signatures.create 
  end
end

class User < Ohm::Model
  include OmniAuth::Identity::Model
  include BCrypt
  attribute :name
  attribute :email
  attribute :password_hash

  attr_accessor :password_confirmation

  index :name
  index :email
  collection :signatures, Signature

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create new_password
    self.password_hash = @password
  end

  def persisted?
    self.id != nil
  end

  def authenticate(password)
    (self.password == password) ? self : false
  end

  def self.locate(key)
    self.find(email: key).first
  end

  def self.find_or_create_by_facebook(hash)
    
  end

end
