require 'sinatra'
require 'json'
require 'git'
require 'heroku'
require 'coffee-script'
require 'less'
require 'logger'
require 'dalli'
require 'memcachier'

require './config/environments'
require './config/cache'
require './config/version'

get '/' do
  redirect "https://github.com/petehamilton/classy-cate#classy-cate"
end

# Serve UserScript
get '/classy-cate.user.js' do
  content_type 'application/javascript'
  get_cache('classy-cate-user-js', settings.asset_cache_for) {
    erb(:"classy-cate.user.js")
  }
end

# Serve ClassyCATE JS
get '/classy-cate.js' do
  content_type 'application/javascript'
  get_cache('classy-cate-js', settings.asset_cache_for) {
    coffee(erb(:"classy-cate.coffee"))
  }
end

# Serve ClassyCATE CSS
get '/classy-cate.css' do
  content_type 'text/css'
  get_cache('classy-cate-css', settings.asset_cache_for) {
    less(:"classy-cate")
  }
end

# Serve uncompiled coffeescript - debugging
get '/classy-cate.coffee' do
  content_type 'text/text'
  erb(:"classy-cate.coffee")
end

####################################################################
# AUTO DEPLOY METHODS - DO NOT CHANGE!
####################################################################
get '/public_key' do
  require_relative 'lib/init'
  ::CURRENT_SSH_KEY
end

get '/status' do
  require_relative 'lib/init'
  c = GitPusher.local_state(ENV['GITHUB_REPO'])
  "SHA: #{c.sha} | Date: #{c.date}"
end

get '/nuke-repos' do
  require_relative 'lib/init'
  `rm -r repos`
  "nuked!"
end

get '/force-push' do
  require_relative 'lib/init'
  GitPusher.deploy(ENV['GITHUB_REPO'])
  "Success!"
end

post '/post-receive' do
  require_relative 'lib/init'
  data = JSON.parse(params[:payload])
  url = data["repository"]["url"]
  GitPusher.deploy(url)
  begin
    logger.info "Flushing the Cache Post-Deploy"
    settings.cache.flush_all
  rescue Dalli::NetworkError
  end
  "Success!"
end
