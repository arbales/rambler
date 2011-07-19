env = process.env
exports.db = mongoose = require 'mongoose'
exports.Schema = Schema = mongoose.Schema
exports.mongooseAuth = mongooseAuth = require 'mongoose-auth'


ObjectId = Schema.ObjectId

UserSchema = new Schema({})
UserSchema.plugin mongooseAuth,
  everymodule:
    everyauth:
      User: ->
        User
  facebook:
    everyauth:
      myHostname: 'http://localhost:3000'
      appId: env.FACEBOOK_APP_ID
      appSecret: env.FACEBOOK_APP_SECRET
      redirectPath: '/'


PostSchema = new Schema({
  author: ObjectId
  title: String
  body: String
  date: Date
  channel: String
  meta: {
    votes: Number
    favs: Number
  }
})

# Create models from Schema declarations.
mongoose.model 'User', UserSchema
mongoose.model 'Post', PostSchema

# Connect to the datastore.
mongoose.connect('mongodb://localhost/rambler2_development')

# Expose `User` to mongooseAuth.
User = mongoose.model 'User'
