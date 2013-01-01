set_default(:backup_postgres_socket_path, "/var/run/postgres")
set_default(:backup_encryption_password) { Capistrano::CLI.password_prompt "Choose an encryption password: " }
set_default(:backup_backup_server_pass) { Capistrano::CLI.password_prompt "Choose an encryption password: " }
set_default(:backup_backup_server_host)  { Capistrano::CLI.password_prompt "What is your backup server's hostname? " }
set_default(:backup_backup_server_user)  { Capistrano::CLI.password_prompt "What is your backup server's username? " }
set_default(:backup_backup_server_path)  { Capistrano::CLI.password_prompt "What is the backup path on your backup server? " }
set_default(:backup_rsync_push_directories) { ["#{shared_path}/system","#{shared_path}/config"] }

namespace :backup do
  desc "Install the backup gem."
  task :install do
    run "mkdir #{shared_path}/config/models"
    template "backup/recipe.rb.erb",  "#{shared_path}/config/models/backup.rb"
    template "backup/config.rb.erb",  "#{shared_path}/config/config.rb"
    template "backup/backup.yml.erb", "#{shared_path}/config/backup.yml"
  end
  after "deploy:install", "backup:install"

  desc "Symlink the backup.yml file to the current release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/backup.yml #{release_path}/config/backup.yml"
  end
  after "deploy:finalize_update", "backup:symlink"
end
