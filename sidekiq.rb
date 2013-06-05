namespace :sidekiq do
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/sidekiq.yml #{release_path}/config/sidekiq.yml"
  end
  before "deploy:start",   "sidekiq:symlink"
  before "deploy:restart", "sidekiq:symlink"
end
