namespace :bundler do
  task :install do
    run <<-RUN
      cd #{release_path} && \
      bundle install --path #{shared_path}/bundle --without development test
    RUN
  end
  before 'deploy:finalize_update', 'bundler:install'
end
