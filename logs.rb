namespace :logs do
  desc "Get ouput of env's log file"
  task :tail do
    stream "tail -n 300 -f #{current_path}/log/#{stage}.log"
  end
end
