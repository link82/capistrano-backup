require "bundler/capistrano"

load "config/recipes/backup"

set :domain, "mydoamain"

role :app, domain
role :web, domain
role :db,  domain, :primary => true

## USED BY MONIT TO SEND NOTIFICATION EMAILS
set :mailer_user, "emailforsmtp@yourdomain.com"
set :mailer_pass, "your password"

set :admin_email, "mailme@here.com"



set :application, "myapp"

#NEEDE TO MATCH HIS DIFFERENT NAME
set :database_name, "database_name"

set :user, "deploy_user"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository,  "git@github.com:user/reponame.git"  #"git@heroku.com:needle-me.git"
set :branch, "master"



default_run_options[:pty] = true
ssh_options[:forward_agent] = true
#ssh_options[:verbose] = :info


