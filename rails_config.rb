namespace :rails_config do
  desc "Symlink the important config files to the current release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/production.yml #{release_path}/config/settings/production.yml"
  end
  after "deploy:finalize_update", "rails_config:symlink"
end
