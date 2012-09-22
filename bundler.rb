namespace :bundler do

  task :update do
    copy_production_gemfile
    install
    el_jefe
  end

  task :copy_production_gemfile do
    run <<-RUN
      mv #{release_path}/Gemfile.prod #{release_path}/Gemfile
    RUN
  end

  task :install do
    run <<-RUN
      cd #{release_path} &&
      bundle install --path #{shared_path}/bundle --without development test
    RUN
  end

  task :el_jefe do
    run <<-RUN
      cd #{release_path} &&
      bundle update el_jefe
    RUN
  end

  before 'deploy:finalize_update', 'bundler:update'
end
