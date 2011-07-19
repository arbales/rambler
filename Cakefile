db = require('./models').db 
sys = require 'sys'

task "posts:clean", "Clean all posts. This is an awful idea.", ->
  Post = db.model "Post"
  if Post.find({}).remove({})
    sys.puts "Posts Cleaned"
  else
    sys.puts "Failure"