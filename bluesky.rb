namespace :bluesky do
  desc "Symlink the important app files to the current release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/comfy_zugriff.yml #{release_path}/config/comfy_zugriff.yml"
  end
  after "deploy:finalize_update", "bluesky:symlink"
end
