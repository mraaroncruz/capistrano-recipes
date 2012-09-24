namespace :el_jefe do
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/el_jefe.yml #{release_path}/config/initializers/el_jefe.yml"
  end
  after "deploy:finalize_update", "el_jefe:symlink"
end
