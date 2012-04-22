object @user
attributes :name

child @user.signatures do
  attribute :expires_at
  attribute :channel_name
  attribute :token
  attribute :read_only
end