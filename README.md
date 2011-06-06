# Rambler, the next generation
It's in Node and a saner front-end now.

# Development
Uses the `hub` gem. You also need **NPM**, Ruby 1.9.2 + Bundler. Prolly put CoffeeScript in your globals? `npm install coffee-script -g`

```
  cd ~/Workspace
  git clone arbales/rambler-simple
  cd rambler-simple
  
  npm install
  coffee server.coffee    
```

# Sass
```
  cd ~/Workspace/rambler-simple
  bundle install
  cd ./public
  compass watch
```

# Reload
Run `npm install supervisor -g` and then `supervisor server.coffee`