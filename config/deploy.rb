$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.2@plat_forms_2011'        # Or whatever env you want it to run in.

ssh_options[:forward_agent] = true

set :user, 'tmp8'
set :domain, 'p'
set :application, 'plat_forms_2011'

# file paths
set :repository,  "#{user}@#{domain}:~/repos/#{application}/.git" 
set :deploy_to, "/home/#{user}/#{application}" 

# distribute your applications across servers (the instructions below put them
# all on the same server, defined above as 'domain', adjust as necessary)
role :app, domain
role :web, domain
role :db, domain, :primary => true


# miscellaneous options
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false

namespace :deploy do

  desc "cause App to initiate a restart"
  task :restart do
    run "cd #{current_path}; rake sunspot:solr:stop sunspot:solr:start sunspot:reindex RAILS_ENV=production "
    run "touch #{current_path}/tmp/restart.txt" 
  end

  desc "reload the database with seed data"

  task :seed do
    run "cd #{current_path}; rake db:seed RAILS_ENV=production"
  end
end

after "deploy:update_code", :bundle_install, :symlink_config
desc "install the necessary prerequisites"
task :bundle_install, :roles => :app do
  run "cd #{release_path} && bundle install"
end

task :symlink_config do
  run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end
