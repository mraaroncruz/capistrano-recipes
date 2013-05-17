namespace :scheduler do
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/el_jefe.yml #{release_path}/config/initializers/el_jefe.yml"
    run "ln -nfs #{shared_path}/db/production.config.store #{release_path}/db/production.config.store"
    run "ln -nfs #{shared_path}/db/el_jefe.backup #{release_path}/db/el_jefe.backup"
    run "ln -nfs #{shared_path}/db/el_jefe.configuration #{release_path}/db/el_jefe.configuration"
  end
  after "deploy:finalize_update", "scheduler:symlink"
end
