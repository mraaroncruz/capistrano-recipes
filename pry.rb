namespace :pry do
  desc "Connect to console"
  task :console do
    hostname = find_servers_for_task(current_task).first
    exec "ssh -t #{hostname} 'source ~/.zshrc && cd #{current_path} && bundle exec rails c #{stage}'"
  end
end
