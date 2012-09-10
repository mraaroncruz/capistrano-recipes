#!/usr/bin/env rake
require 'resque/tasks'

task "resque:setup" => :environment

# Start a worker with proper env vars and output redirection
def run_worker(queue = "*", count = 1)
  puts "Starting #{count} worker(s) with QUEUE: #{queue}"
  ops = {:pgroup => true,
    :err => [("#{File.dirname(__FILE__)}/log/resque_err").to_s, "a"], 
    :out => [("#{File.dirname(__FILE__)}/log/resque_stdout").to_s, "a"]
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
  task :setup => :environment

  desc "Restart running workers"
  task :restart => :environment do
    Rake::Task['resque:stop'].invoke
    Rake::Task['resque:start'].invoke
  end

  desc "Quit running workers"
  task :stop => :environment do
    pids = Resque.workers.map { |w| w.worker_pids }.flatten.uniq
    if pids.empty?
      puts "No workers to kill"
    else
      syscmd = "kill -s QUIT #{pids.join(' ')}"
      puts "Running syscmd: #{syscmd}"
      system(syscmd)
    end
  end

  desc "Start workers"
  task :start => [:environment, "resque:setup"] do
    run_worker("*", 4)
  end
end
