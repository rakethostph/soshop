# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

# Change these
server '142.93.16.233', port: 22, roles: [:web, :app, :db], primary: true

set :repo_url,        'https://github.com/rakethostph/soshop.git'
set :application,     'soshop'
set :user,            'soshop_ph'
set :puma_threads,    [4, 16]
set :puma_workers,    0

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord
# append :linked_files, 'config/database.yml'
append :linked_files, 'config/master.key'


set :chewy_conditionally_reset, false    # Reset only modified Chewy indexes, true by default
set :chewy_path, 'soshop/index'        # Path to Chewy indexes, 'app/chewy' by default
set :chewy_env, :chewy_production        # Environment variable for Chewy, equal to RAILS_ENV by default
set :chewy_role, :web                    # Chewy role, :app by default  
set :chewy_default_hooks, false          # Add default gem hooks to project deploy flow, true by default
set :chewy_delete_removed_indexes, false # Delete indexes which files have been deleted, true by default

# sudo ln -nfs "/home/soshop_ph/soshop/current/config/nginx.conf" "/etc/nginx/sites-enabled/soshop"

## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
# set :linked_files, %w{config/database.yml}
# set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  namespace :rake do
    desc "Invoke rake task"
    task :invoke do
      run "cd #{deploy_to}/current"
      run "bundle exec rake #{ENV['task']} RAILS_ENV=#{rails_env}"
    end
  end
  namespace :rails do
    desc 'Open a rails console `cap [staging] rails:console [server_index default: 0]`'
    task :console do
      server = roles(:app)[ARGV[2].to_i]

      puts "Opening a console on: #{server.hostname}…."

      cmd = "ssh #{server.user}@#{server.hostname} -t 'cd #{fetch(:deploy_to)}/current && RAILS_ENV=#{fetch(:rails_env)} bundle exec rails console'"

      puts cmd

      exec cmd
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end