# Get bundle install --deployment for free w/ nice symlink behavior
require "bundler/capistrano"

# Require the recipes you need, comment out the ones you don't
load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
load "config/recipes/check"

# Your remote server. If you have separate db, app,
# and web servers, you can split this up into
# role :web, "8.8.8.8"
# role :app, "8.8.8.1"
# ...
#
server "8.8.8.8", :web, :app, :db, primary: true

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
