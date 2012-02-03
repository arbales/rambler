# Rambler, the next generation
It's in Node and a saner front-end now. See Rambler1 at http://rambler.pris.ma or http://github.com/arbales/rambler-rb. Awful.

# Development
You need **NPM**, Ruby 1.9.2 + Bundler. Prolly put CoffeeScript in your globals? `npm install coffee-script -g`

```sh
  cd ~/Workspace
  git clone https://arbales@github.com/arbales/rambler-simple.git
  cd rambler-simple
  
  npm install
  coffee server.coffee         
  
```

## Sass
```sh
  cd ~/Workspace/rambler-simple
  bundle install
  cd ./public
  compass watch
```
       
## Reload
Run `npm install supervisor -g` and then `supervisor server.coffee`

## Configurate

You'll need the following envars set...

### To use GitHub organization-limited auth...
```sh
  GITHUB_APP_ID=''
  GITHUB_APP_SECRET=''
  GITHUB_ORGANIZATION_NAME='multimoon'
```      

### To use Facebook auth
```sh
  FACEBOOK_APP_ID=''
  FACEBOOK_APP_SECRET=''
```      

#### Danger
Auth right now is a joke. It authenticates you as a Facebook user to show you a view, but nothing else. You can easily post whatever you want to the API.


## TODO                                       

### Fix
  
* Not illusionary security. Basically, actually security.  
* Real Backbone models.
* Google apps login, too?

### Then       
        
* Chrome Notifications
* Topic/Channel Sidebar (places you've posted in) and Mentions (both show a list of messages, the latter is read-only)
* Direct Messages
                       
### DSL for interesting things.
    
* `topic: That's no moon…` could set the topic.
* `@username you're dumb` could bold a message, issue a counter update, and maybe send an e-mail
* `imageme: Honey Badger` client-side image me.