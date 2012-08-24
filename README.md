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

