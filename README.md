## Capistrano Recipes
Originally borrowed from [Railscasts Episode 337](http://railscasts.com/episodes/337-capistrano-recipes)

## Installation

in your project's root

```
git submodule add git://github.com/pferdefleisch/capistrano-recipes config/recipes
cd config/recipes
./install # this copies the deploy-example.rb file to config/deploy.rb
```

### in your deploy.rb

* add your server information
* remove the recipes you don't want

## Other Resources

* [List of all Capistrano default tasks](https://github.com/capistrano/capistrano/wiki/Capistrano-Tasks)
* [List of Capistrano variables](https://github.com/capistrano/capistrano/wiki/2.x-Significant-Configuration-Variables)

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

## Order of tasks for `cap deploy`
> note: this and the next section are taken almost word for word from [RailsCasts #133](http://railscasts.com/episodes/133-capistrano-tasks)

1. `deploy:update_code`
2. `deploy:symlink_shared`
3. `deploy:symlink`
4. `deploy:restart`

## Directory Structure after running `cap deploy:setup`

```
myapp/releases
myapp/current -> releases/20081019001122
myapp/shared
```
