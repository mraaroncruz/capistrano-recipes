namespace :bundler do

  task :install do
    run <<-RUN
      cd #{release_path} &&
      RAILS_ENV=production bundle install --gemfile #{release_path}/Gemfile --path #{shared_path}/bundle --quiet --without development test
    RUN
  end

  before 'deploy:finalize_update', 'bundler:install'
end
