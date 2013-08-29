set_default(:backup_db_host, "localhost")
set_default(:backup_db_user) { "db_user" }
set_default(:backup_db_password) { "db_pass" }
set_default(:backup_db_name) { "#{database_name}" }

set_default(:s3_access_key) { "s3_key" }
set_default(:s3_secret_key) { "s3_secret" }
set_default(:s3_region) { "us-east-1" }
set_default(:s3_bucket) { "bucket_name" }
set_default(:s3_path) { "" } #don't use / in path, there seems to be a bug
set_default(:max_backups){ 7 } #how many backups do you want to keep


set :email_from, "server@mydomain.com"
set :backup_hour, 5 #dont use 05 or it will not work
set :backup_minutes, 0

namespace :backup do

  desc "Install the required gem and create directory structure for backups"
  task :install, roles: :db, only: {primary: true} do
    run "cd ~"
    run "gem install backup --no-ri --no-rdoc"
    run "mkdir -p ~/Backup/models Backup/log ~/Backup/data"
  end

  desc "Setup automatic database backups"
  task :setup, roles: :db, only: {primary: true} do
    
    #backup model file
    template "backup/backup.erb", "/tmp/backup"
    run "mv -f /tmp/backup ~/Backup/models/#{application}.rb"

    #generic backup config file
    template "backup/config.erb", "/tmp/config_backup"
    run "mv -f /tmp/config_backup ~/Backup/config.rb"

    #contains backup command to execute
    template "backup/cron_script.erb", "/tmp/cron_script"
    run "mv -f /tmp/cron_script ~/#{application}_script"
    run "chmod +x ~/#{application}_script"

    #contains crontab schedule and file to lauch
    template "backup/cron_command.erb", "/tmp/cron_command"
    run "mv -f /tmp/cron_command ~/#{application}_cron"
    run "chmod +x ~/#{application}_cron"

    run "crontab ~/#{application}_cron"
  end

  desc "Perform backup now"
  task :perform, roles: :db, only: {primary: true} do
    run "cd ~"
    run "backup perform -t <%= application %>"
  end

end
