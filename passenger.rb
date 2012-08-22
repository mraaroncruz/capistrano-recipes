namespace :passenger do
  task :start {}
  task :stop  {}
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  after 'deploy:restart', 'passenger:restart'
end
