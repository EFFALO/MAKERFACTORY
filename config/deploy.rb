set :application, "MAKERFACTORY"

require "bundler/capistrano"
set :bundle_flags, "--deployment --local --quiet"
set :bundle_cmd, "/home/makerfactory/.gems/bin/bundle"

set :user, "makerfactory"
set :use_sudo, false

set :repository,  "git://github.com/EFFALO/MAKERFACTORY.git"
set :scm, :git
set :branch, ENV['BRANCH'] ||= 'master'
set :directory, ENV['DOMAIN'] ||= 'staging.makerfactory.com'
set :deploy_to, "/home/#{user}/#{directory}"
set :deploy_via, :remote_cache
ssh_options[:forward_agent] = true

set :default_environment, { :GEM_HOME  => "#{shared_path}/.gems",
                            :GEM_PATH  => "#{shared_path}/.gems",
                            :PATH      => "#{shared_path}/.gems/bin:$PATH",
                            :RAILS_ENV => "production"}

#role :web, web_server
role :app, ENV['SERVER'] ||= "staging.makerfactory.com"
#role :db,  db_server, :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :makerfactory do
  task :gem_path do
    run <<-EOC
      sed '1 a \ENV["GEM_PATH"] = File.expand_path("~/.gems")' #{current_path}/config/preinitializer.rb > ~/tmpfile
    EOC
    run "mv ~/tmpfile #{current_path}/config/preinitializer.rb"
  end
  
  task :link_config_files do
    run "ln -nsf #{shared_path}/config/database.yml #{current_path}/config/database.yml"
    run "ln -nsf #{shared_path}/config/errbit.rb #{current_path}/config/initializers/errbit.rb"
    run "ln -nsf #{shared_path}/config/mail.rb #{current_path}/config/mail.rb"
  end

  task :test_errbit do
    run "cd #{current_path}; #{bundle_cmd} exec rake hoptoad:test" 
  end

  task :install_bundler do
    run "gem install bundler"
  end

  task :refresh_images do
    run "cd #{current_path}; CLASS=User #{bundle_cmd} exec rake paperclip:refresh"
    run "cd #{current_path}; CLASS=Job #{bundle_cmd} exec rake paperclip:refresh"
  end

  task :env do
    run "env", :env => {:test => "test" }
  end


end

after('deploy:setup', 'makerfactory:install_bundler')
after('deploy:symlink', 'makerfactory:link_config_files')
after('deploy:symlink', 'makerfactory:gem_path')
