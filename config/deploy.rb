require 'erb'

role :app, "domain_or_ip"
role :web, "domain_or_ip"
role :db,  "domain_or_ip", :primary => true

set :application, "makerfactory"
set :repository,  "git@github:makerfactory.git"
#set :use_sudo, false
set :user, "deploy"
set :deploy_via, :remote_cache
set :scm, :git
default_run_options[:pty] = true
#ssh_options[:port] = 30000

# Customise the deployment

set :keep_releases, 3
before "deploy:setup", :db
after "deploy:update", "deploy:cleanup"
# after "deploy:update", "deploy:cleanup"
after "deploy:symlink", "deploy:update_crontab"

# directories to preserve between deployments
# set :asset_directories, ['public/system/logos', 'public/system/uploads']

# re-linking for config files on public repos  
# namespace :deploy do
#   desc "Update the crontab file"
#   task :update_crontab, :roles => :db do
#     run "cd #{release_path} && whenever --update-crontab #{application}"
#   end
#   desc "Re-link config files"
#   task :link_config, :roles => :app do
#     run "ln -nsf #{shared_path}/config/database.yml #{current_path}/config/database.yml"
#   end
# end

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :db do
  desc "Create database yaml in shared path" 
  task :default do
    db_config = ERB.new <<-EOF
production:
  username: 
  password: 
  adapter:  mysql
  encoding: utf8
  database: "makerfactory_production"
EOF

    run "mkdir -p #{shared_path}/config" 
    put db_config.result, "#{shared_path}/config/database.yml" 
  end

  desc "Make symlink for database yaml" 
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end
end

    
