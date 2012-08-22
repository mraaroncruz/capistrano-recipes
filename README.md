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
