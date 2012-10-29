namespace :logs do
  desc "Get ouput of env's log file"
  task :tail do
    stream "tail -n 300 -f #{current_path}/log/production.log"
  end

  desc "View htop"
  task :htop do
    hostname = find_servers_for_task(current_task).first
    exec "ssh -t #{hostname} 'htop'"
  end

  desc "View htop"
  task :htop do
    hostname = find_servers_for_task(current_task).first
    exec "ssh -t #{hostname} 'htop'"
  end
end
