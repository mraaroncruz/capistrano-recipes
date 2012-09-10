namespace :passenger do
  task :start do end
  task :stop  do end
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  after 'deploy:restart', 'passenger:restart'
end
