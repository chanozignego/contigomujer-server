### SECTION :basic_requires
require 'recap/recipes/rails'

### SECTION :default_paths
set :config_path, File.expand_path(File.dirname(__FILE__), 'config')
set :db_backup_path, '/var/backups/db'

### SECTION :install_recipes
require 'stackmint/capistrano/scm'
require 'stackmint/capistrano/base'
require 'stackmint/capistrano/utils'
require 'stackmint/capistrano/nginx'
require 'stackmint/capistrano/recap'
require 'stackmint/capistrano/rvm'
require 'stackmint/capistrano/git'
require 'stackmint/capistrano/bundler'
require 'stackmint/capistrano/redis'
require 'stackmint/capistrano/nodejs'
require 'stackmint/capistrano/postgresql'

### SECTION :scm
# Use Git as Version Control System

### SECTION :ssh_config
default_run_options[:pty]              = true
ssh_options[:forward_agent]            = true
ssh_options[:port]                     = 22
### ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "dev7")]

set :repository, "git@github.com:chanozignego/contigomujer-server.git"
set :user, 'ubuntu'


### SECTION :install callbacks
after "host:install",
  "nginx:install",
  "rvm:install",
  "rvm:install_ruby",
  "bundler:install",
  "nodejs:install",
  "dev_lib:install",
  "rvm:add_user_to_rvm"

# before "bootstrap",
#   "git_config:setup"

after "bootstrap",
  "rvm:add_app_to_rvm"

after "deploy:setup",
  "nginx:setup:puma"

task :staging do
  set :application_name, "contigomujer-staging"
  set :application, application_name
  set_default_env :SOCK_NAME, "puma.#{application}.sock"
  set :branch, "develop"
  set :domain, "54.213.175.85"
  set :user, "redmint"
  server "simp.redmintlabs.com", :web, :app, :db, primary: true

  namespace :bundle do
    task :check_installed do
      run("echo OVERRULED")
    end
  end

  namespace :foreman do
    set(:foreman_concurrency) { "puma=1,sidekiq=1,redis=1" }
    set(:foreman_export_command) { "./bin/foreman export #{foreman_export_format} #{foreman_tmp_location} --procfile #{procfile} --app #{application} --user #{application_user} --log #{deploy_to}/log #{foreman_template_option} --concurrency #{foreman_concurrency}" }

    task :restart, roles: :app do
      foreman.export
      run "(#{sudo} kill -s 10 $(ps -C ruby -F | grep '#{application}' | grep 'puma' | awk {'print $2'})) || #{sudo} service #{application} restart"
    end

  end
end

task :current do
  set :application_name, "contigomujer-current"
  set :application,      application_name
  set :branch,            `git rev-parse --abbrev-ref HEAD` # current branch
  set :domain, "simp.redmintlabs.com"                     # test server
  set :deploy_to, "/home/#{application}/app"
  server "simp.redmintlabs.com", :web, :app, :db, :primary => true
end

task :production do
  set :application_name, "contigomujer"
  set :application, application_name
  set :branch, "master"
  set :domain, "54.86.45.121"
  server "#{domain}", :web, :app, :db, :primary => true

  namespace :foreman do
    set(:foreman_concurrency) { "puma=1,sidekiq=1,redis=1" }
    set(:foreman_export_command) { "./bin/foreman export #{foreman_export_format} #{foreman_tmp_location} --procfile #{procfile} --app #{application} --user #{application_user} --log #{deploy_to}/log #{foreman_template_option} --concurrency #{foreman_concurrency}" }

    task :restart, roles: :app do
      foreman.export
      run "(#{sudo} kill -s 10 $(ps -C ruby -F | grep '#{application}' | grep 'puma' | awk {'print $2'})) || #{sudo} service #{application} restart"
    end
  end
end

namespace :bundle do
   task :check_installed do
     run("echo OVERRULED")
   end
 end

#### Extra
#
## New Relic Integration
#require 'new_relic/recipes'
#after "deploy", "newrelic:notice_deployment"
