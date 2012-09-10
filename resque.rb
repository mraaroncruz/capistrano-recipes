require 'resque'

set_default(:resque_worker_count, 4)

# Start a worker with proper env vars and output redirection
def run_worker(queue = "*", count = 1)
  puts "Starting #{count} worker(s) with QUEUE: #{queue}"
  ops = {:pgroup => true, 
    :err => [
      (File.expand_path('../../../', __FILE__) + "/log/resque_err").to_s, "a"], 
    :out => [
      (File.expand_path('../../../', __FILE__) + "/log/resque_stdout").to_s, "a"]
  }
  env_vars = {"QUEUE" => queue.to_s}
  count.times {
    ## Using Kernel.spawn and Process.detach because regular system() call would
    ## cause the processes to quit when capistrano finishes
    pid = spawn(env_vars, "bundle exec rake resque:work", ops)
    Process.detach(pid)
  }
end

namespace :resque do

  desc "Start resque processes"
  task :start do
    run ". ~/.zshrc && cd #{current_path} && bundle exec rake resque:start"
  end

  desc "Quit running workers"
  task :stop do
    run ". /home/#{user}/.zshrc && cd #{current_path} && bundle exec rake resque:stop"
  end

  desc "Restart running workers"
  task :restart do
    stop
    start
  end

  %w[stop start restart].each do |command|
    after "deploy:#{command}", "resque:#{command}"
  end
end
