request = require 'request'
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
      myHostname: 'http://austin.local'
      appId: env.FACEBOOK_APP_ID
      appSecret: env.FACEBOOK_APP_SECRET
      redirectPath: '/'
  github:
    everyauth:
      myHostname: 'http://localhost:3000'
      appId: env.GITHUB_APP_ID
      appSecret: env.GITHUB_APP_SECRET
      scope: 'repo'
      redirectPath: '/' 
      findOrCreateUser: (sess, accessTok, accessTokExtra, ghUser) ->
        promise = @Promise()
        
        request
          method: 'GET'
          headers:
            "Authorization": "token #{accessTok}" 
          uri: "https://api.github.com/orgs/#{env.GITHUB_ORG_NAME}"
          ,
          (errors, response, body) =>
            if response.statusCode isnt 201
              promise.fail()
            else
              # TODO Check user in session or request helper first
              #      e.g., req.user or sess.auth.userId
              @User()().findOne {'github.id': ghUser.id}, (err, foundUser) =>
                if foundUser
                  promise.fulfill foundUser
                @User()().createWithGithub ghUser, accessTok, (err, createdUser) ->
                  promise.fulfill createdUser
        
            return promise


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
