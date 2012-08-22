require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
load "config/recipes/check"

server "8.8.8.8", :web, :app, :db, primary: true

set :user, "app"
set :application, "my_application"
set :deploy_to, "/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:#{user}/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases
