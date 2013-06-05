# Get bundle install --deployment for free w/ nice symlink behavior
require "bundler/capistrano"

# Require the recipes you need, comment out the ones you don't
load "config/recipes/base"
load "config/recipes/check"
#load "config/recipes/asset_pipeline"
#load "config/recipes/backup"
#load "config/recipes/carrierwave"
#load "config/recipes/logrotate"
#load "config/recipes/logs"
#load "config/recipes/passenger"
#load "config/recipes/postgresql"
#load "config/recipes/pry"
#load "config/recipes/nginx"
#load "config/recipes/nodejs"
#load "config/recipes/rails_config"
#load "config/recipes/rbenv"
#load "config/recipes/resque"
#load "config/recipes/sidekiq"
#load "config/recipes/unicorn"

# Your remote server. If you have separate db, app,
# and web servers, you can split this up into
# role :web, "8.8.8.8"
# role :app, "8.8.8.1"
# ...
#
server "8.8.8.8", :web, :app, :db, primary: true
# Setup stages that then have corresponding deploy config files
# in the config/deploy/ directory
# ex. config/deploy/production.rb has your production env specific
# deployment configuration. then run
# cap production deploy
# for that configuration or set production to default stage and run
# cap deploy
#
set :stages, %w[staging workers production]
set :default_stage, 'production'
require "capistrano/ext/multistage"
# Application name - to conventionalize directory/project naming
set :application, "my_application"
# Same as above
set :user, "app"
# Your application's root directory
set :deploy_to, "/apps/#{application}"
# Fetch copies of repo instead of cloning on each deploy
set :deploy_via, :remote_cache
# Don't use sudo as default
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:#{user}/#{application}.git"
set :branch, "master"

# Password prompt instead of cryptic error on remote sudo commands
default_run_options[:pty] = true
# No need for a repo checkout deploy key on your deployment server
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases
