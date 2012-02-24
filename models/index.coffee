request = require 'request'
env = process.env
exports.db = mongoose = require 'mongoose'
exports.Schema = Schema = mongoose.Schema
exports.mongooseAuth = mongooseAuth = require 'mongoose-auth'


ObjectId = Schema.ObjectId

UserSchema = new Schema {}
UserSchema.plugin mongooseAuth,
  everymodule:
    everyauth:
      User: ->
        User

  facebook:
    everyauth:
      myHostname: env.RAMBLER_URL
      appId: env.FACEBOOK_APP_ID
      appSecret: env.FACEBOOK_APP_SECRET
      redirectPath: '/'

      findOrCreateUser: (sess, accessToken, accessTokenExtra, fbUser) ->
        User = this.User()()
        promise = this.Promise()

        User.findOne {'facebook.id': fbUser.id}, (err, user) =>
          if err
            return promise.fail err
          if user
            return promise.fulfill user
          else
            expiresDate = new Date
            expiresDate.setSeconds expiresDate.getSeconds() + 500
            params =
              fb:
                id: fbUser.id
                accessToken: accessToken
                expires: expiresDate
                name:
                  full: fbUser.name
                  first: fbUser.first_name
                  last: fbUser.last_name
                alias: fbUser.link.match(/^http:\/\/www.facebook\.com\/(.+)/)[1]
                gender: fbUser.gender
                email: fbUser.email
                timezone: fbUser.timezone
                locale: fbUser.locale
                verified: fbUser.verified
                updatedTime: fbUser.updated_time

              # TODO Only do this if password module is enabled
              #      Currently, this is not a valid way to check for enabled
              # if everyauth.password
              #  params[everyauth.password.loginKey()] = "fb:" + fbUserMeta.id; // Hack because of way mongodb treate unique indexes

            User.create params, (error, createdUser) ->
              promise.fulfill createdUser

        return promise
        
        
  # github:
  #   everyauth:
  #     myHostname: env.RAMBLER_URL
  #     appId: env.GITHUB_APP_ID
  #     appSecret: env.GITHUB_APP_SECRET
  #     scope: 'repo'
  #     redirectPath: '/'
  #     findOrCreateUser: (sess, accessTok, accessTokExtra, ghUser) ->
  #       promise = @Promise()
  #
  #       request
  #         method: 'GET'
  #         headers:
  #           "Authorization": "token #{accessTok}"
  #         uri: "https://api.github.com/orgs/#{env.GITHUB_ORG_NAME}"
  #         ,
  #         (errors, response, body) =>
  #           if response.statusCode isnt 201
  #             promise.fail()
  #           else
  #             # TODO Check user in session or request helper first
  #             #      e.g., req.user or sess.auth.userId
  #             @User()().findOne {'github.id': ghUser.id}, (err, foundUser) =>
  #               if foundUser
  #                 promise.fulfill foundUser
  #               else
  #                 @User()().createWithGithub ghUser, accessTok, (err, createdUser) ->
  #                   promise.fulfill createdUser
  #
  #           return promise


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
