namespace :assets do

  task :precompile, role: :app  do
    if File.directory? File.expand_path('../../../public/assets', __FILE__)
      puts "USING PREVIOUSLY COMPILED ASSETS"
    else
      system "bundle exec rake assets:precompile"
    end
  end

  before "deploy:update", "assets:precompile"

  task :rsync, role: :app  do
    puts "Rsyncing assets"
    hostname = find_servers_for_task(current_task).first
    system "rsync -arvz #{File.expand_path("../../../public/assets/", __FILE__)} #{hostname}:#{current_path}/public"
    puts "Rsync complete"
  end

  task :clean, role: :app  do
    system "bundle exec rake assets:clean"
  end

  after "deploy:update", 'assets:rsync'
  after "deploy:cleanup", "assets:clean"
end
