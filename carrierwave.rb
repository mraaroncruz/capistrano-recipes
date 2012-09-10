namespace :carrierwave do
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/uploads/ #{release_path}/public/uploads"
  end
  after "deploy:finalize_update", "carrierwave:symlink"
end

