namespace :pry do
  desc "Connect to console"
  task :console do
    hostname = find_servers_for_task(current_task).first
    exec "ssh #{hostname} -t 'source ~/.zshrc && cd #{current_path} && bundle exec bin/prys'"
  end
end
