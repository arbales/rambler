# Rambler, the next generation
It's in Node and a saner front-end now. See Rambler1 at http://rambler.pris.ma or http://github.com/arbales/rambler. Awful.

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

```sh
  GITHUB_APP_ID=''
  GITHUB_APP_SECRET=''
  GITHUB_ORGANIZATION_NAME='multimoon'
```