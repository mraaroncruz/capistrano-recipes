set_default(:backup_encryption_password) { Capistrano::CLI.password_prompt "Choose an encryption password: " }
set_default(:backup_backup_server_host)  { Capistrano::CLI.password_prompt "What is your backup server's hostname? " }
set_default(:backup_backup_server_user)  { Capistrano::CLI.password_prompt "What is your backup server's username? " }
set_default(:backup_backup_server_path)  { Capistrano::CLI.password_prompt "What is the backup path on your backup server? " }

namespace :backup do
  desc "Install the backup gem."
  task :install do
    run "#{sudo} gem install backup net-ssh"
    template "backup/backup.yml", "#{shared_path}/config/backup.yml"
    template "backup/recipe.rb", "#{shared_path}/config/recipe.rb"
  end
  after "deploy:install", "backup:install"

  desc "Symlink the backup.yml file to the current release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/backup.yml #{release_path}/config/backup.yml"
  end
  after "deploy:finalize_update", "backup:symlink"
end
