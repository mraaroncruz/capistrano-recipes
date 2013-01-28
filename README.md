## Capistrano Recipes
Originally borrowed from [Railscasts Episode 337](http://railscasts.com/episodes/337-capistrano-recipes)

## Installation

in your project's root

```
git submodule add git://github.com/pferdefleisch/capistrano-recipes config/recipes
cd config/recipes
./install # this copies the deploy-example.rb file to config/deploy.rb
cd ../..
capify .
```

### in your deploy.rb

* add your server information
* remove the recipes you don't want

## Recipes

I have marked tasks that occur automatically during deployment when requiring the recipe in `config/deploy.rb` with *[automatic]*

### asset_pipeline

__before__

*[automatic]* precompiles your Rails assets locally

__after `deploy:update`__

*[automatic]* rsyncs them to the server after `deploy:update` hook

`deploy:clean`

*[automatic]* removes your local `public/assets` folder after deployment

### backup

__variables__

`backup_postgres_socket_path`: `"/var/run/postgres"`  
`backup_encryption_password`: prompts for encryption password  
`backup_backup_server_pass`: prompts for backup server password  
`backup_backup_server_host`: prompts for backup server's hostname  
`backup_backup_server_user`: prompts for backu server's username  
`backup_backup_server_path`:  prompts for path to backup to on backup server  
`backup_rsync_push_directories`: which directories to backup with rsync - default: `["#{shared_path}/system"]`  
`backup_archive_daily_folders`: which folders to archive - default: empty array  
`backup_archive_weekly_folders`: which folders to archive weekly - default: `["#{shared_path}/config"]`

__install__

Installs backup gem config files

__symlink__

*[automatic]* symlinks backup.yml file from `shared/config/backup.yml` to `current/config/backup.yml`

### bundler

*[automatic]* I have had to hack my way around bundler installs on my server before. I am now comfortable using `require "bundler/capistrano"` in the deploy.rb file but this is still here for special cases

### carrierwave

*[automatic]* This simply symlinks your `shared/uploads` path to `public/uploads` 

### logrotate

Has a setup task to create a logrotate file for current application. It is pretty hard coded at the moment. The template is in `templates/logrotate.erb`. The current template is pretty robust, I suggest editing the template if you have any specific needs.

### logs

__tail__

tail your `production.log` file. There is not currently a way to tail other log files.o

__htop__

If you have htop installed on your remote server, this will show you the interactive htop screen.

### monit

Currently supports `nginx`, `postgresql` and `unicorn`

__setup__

Installs `monitrc`. You may need to tweak the `set daemon 30` setting, this is how often monit runs its checks.

### nginx

__install__

installs nginx from apt nginx/stable repository

__setup__

sets up unicorn `sites_enabled` config file or app

__controls__

*[automatic]* `start`, `stop`, `restart`

### nodejs

__install__

Installs nodejs on remote server from `ppa:chris-lea/node.js` apt repo. This makes memory hungry `therubyracer` unnecessary. Plus you can now run unbelievably fast and fun to write nodejs utilities on your server :P

### passenger

Restarts passenger after deploy

### postgresql

__variables__

`postgresql_host`: default "localhost"  
`postgresql_user`: default the application var  
`postgresql_password`: prompts for postgresql password  
`postgresql_database`: default `"#{application}_production"`  
`postgresql_dump_path`: default `"#{current_path}/tmp"`  
`postgresql_dump_file`: default `"#{application}_dump.sql"`  
`postgresql_local_dump_path`: default `File.expand_path("../../../tmp", __FILE__)`  
`postgresql_pid`: default `"/var/run/postgresql/9.1-main.pid"`

__install__

Install postgresql apt package on remote server

__create_database__

Prompts for password and creates production database.  
Run before `postgresql:setup` in `deploy:setup` hook.

__setup__

creates database.yml based on `postgresql:create_database` settings.  
Run after `postgresql:create_database` in `deploy:setup` hook.

__console__

Opens an interactive postgresql database console connected to remote server

__local:download__

Download remote database to local `tmp/`

__local:restore__

Restores local database from temp file

__local:localize__

Dump remote database and download it locally  
runs `remote:dump` then `local:download`

__local:sync__

Dump remote database, download it locally and restore local database.  
runs `local:localize` then `local:restore`

__remote:dump__

Dump remote database

__remote:upload__

Uploads local sql.gz file to remote server

__remote:restore__

Restore remote database

__remote:sync__

Uploads and restores remote database.  
runs `remote:upload` then `remote:restore`

### pry

__console__

Opens an interactive rails console with the remote server using `pry` (`pry` must be installed in your rails application or `irb` will be used)

### rails_config

*[automatic]* Symlinks rails_config config files from `shared` to `current`

### rbenv

__variables__
`ruby_version`: ruby version to install - default 1.9.3-p125  
`rbenv_bootstrap`: which ubuntu version gist to use - default: bootstrap-ubuntu-12-04

__install__

Installs `rbenv` and the `bundler` gem


### resque

> *requires Rakefile tasks moved into project*

*[automatic]* controls `stop`, `start` and `restart`

### unicorn

__variables__

`unicorn_pid`: path to your unicorn pid file - default: `#{current_path}/tmp/pids/unicorn.pid`  
`unicorn_config`: path to your unicorn config file - default: `"#{shared_path}/config/unicorn.rb"`  
`unicorn_log` - default: `#{shared_path}/log/unicorn.log`  
`unicorn_workers`: number of child processes unicorn should spawn - default 1

__setup__

creates unicorn config file and moves it into `shared/config/unicorn.rb`  
creates unicorn `init.d` control script  
adds control script as startup script (update-rc.d)

__tail__

tails remote server `current/log/unicorn.log` file

__controls__

*[automatic]* `start`, `stop` and `restart`


# Other Info

## First deploy
__cap deploy:install__  
If you have a new Linux instance you can run this to hook into the install tasks in each of the recipes to install important packages and config files into your system
> note: make sure you read the recipe files that you have loaded in `deploy.rb` because you may need to set config variables like username and path name information

__cap deploy:setup__  
This sets up your directory structure for capistrano in whatever you added to
`set :deploy_to, "/apps/#{application}"`
in your deploy.rb file

__cap deploy:cold__  
This is run on your first deployment or if your application is not running.
It runs `deploy:start` on completion instead of `deploy:restart`

__cap deploy__  
This is what will be run on each subsequent deployment

## Order of tasks for `cap deploy:cold`
> note: `deploy:create_symlink` in versions < 2.10 was called `deploy:symlink`

* `deploy:update`
  * `deploy:updated_code`
    * `deploy:finialize_update`
  * `deploy:create_symlink`
* `deploy:migrate`
* `deploy:start # empty task, user defined`

## Order of tasks for `cap deploy`

* `deploy:update`
  * `deploy:update_code`
    * `deploy:finalize_update`
  * `deploy:create_symlink`
* `deploy:restart # empty task, user defined`

> This [article](https://makandracards.com/makandra/1176-which-capistrano-hooks-to-use-for-events-to-happen-on-both-cap-deploy-and-cap-deploy-migrations) is also helpful about task order

## Directory Structure after running `cap deploy:setup`
> note: this section is taken almost word for word from [RailsCasts #133](http://railscasts.com/episodes/133-capistrano-tasks)

```
myapp/releases
myapp/current -> releases/20081019001122
myapp/shared
```

## Other Resources

* [List of all Capistrano default tasks](https://github.com/capistrano/capistrano/wiki/Capistrano-Tasks)
* [List of Capistrano variables](https://github.com/capistrano/capistrano/wiki/2.x-Significant-Configuration-Variables)

## Copyright
Copyright © 2012-2013 Square Bracket eU, Aaron Cruz. See LICENSE.txt for details.
