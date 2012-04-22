class Signature < Ohm::Model
  attribute :token # TODO: Should I do this? Its not really required…
  attribute :expires_at                                              
  attribute :read_only
  reference :user, User     
  reference :channel, Channel
end                   

class Channel < Ohm::Model
  attribute :name        
  attribute :url
  index :url    
  
  set :members, User
  collection :signatures
  
  def add_member(member)
    self.members.add member
    self.signatures.create 
  end
end

class User < Ohm::Model
  attribute :name
  index :name
  collection :signatures, Signature
end