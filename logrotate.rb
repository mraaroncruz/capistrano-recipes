namespace :logrotate do
  task :setup do
    destination = "/etc/logrotate.d/#{application}"
    template "logrotate.erb", "/tmp/logrotate_#{application}"
    run "#{sudo} mv /tmp/logrotate_#{application} #{destination}"
    run "#{sudo} chown root #{destination}"
    run "#{sudo} chmod 600 #{destination}"
  end

  after "deploy:setup", "logrotate:setup"
end
