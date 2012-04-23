Sinatra::Sprockets.configure do |config|
  ['stylesheets', 'javascripts', 'images'].each do |dir|
    config.append_path(File.join('assets', dir))
  end
  config.app = Rambler::Application
  config.prefix = "/assets"
  config.compile = true
  config.digest = true
  config.append_path 'vendor/assets/javascripts'
  config.js_compressor = Uglifier.new(:copyright => false)
  config.precompile = [ /\w+\.(?!js|css).+/, /application.(css|js)$/ ]
end
