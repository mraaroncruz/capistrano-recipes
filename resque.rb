require 'resque'

set_default(:resque_worker_count, 4)

namespace :resque do

  desc "Start resque processes"
  task :start do
    run "cd #{current_path} && RAILS_ENV=production bundle exec rake resque:start"
  end

  desc "Quit running workers"
  task :stop, on_error: :continue do
    run "cd #{current_path} && RAILS_ENV=production bundle exec rake resque:stop"
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
