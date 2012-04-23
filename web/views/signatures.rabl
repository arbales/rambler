collection @signatures
  attributes :token, :expires_at, :read_only, :user_id
  glue :channel do
    attributes path: :channel_path
  end
