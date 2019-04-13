
set :application, "soshop"
# set :repo_url, "git@github.com:rakethostph/soshop.git"
set :repo_url, "https://github.com/rakethostph/soshop.git"

# Deploy to the user's home directory
set :deploy_to, "/home/soshop_ph/#{fetch :application}"

# append :linked_files, "config/database.yml", "config/secrets.yml", ".env"
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'

# Only keep the last 5 releases to save disk space
set :keep_releases, 5

set :pty, true
# set :puma_conf, "#{shared_path}/config/puma.rb"


# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Optionally, you can symlink your database.yml and/or secrets.yml file from the shared directory during deploy
# This is useful if you don't want to use ENV variables
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

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

  # desc 'Initial Deploy'
  # task :initial do
  #   on roles(:app) do
  #     before 'deploy:restart', 'puma:start'
  #     invoke 'deploy'
  #   end
  # end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  	desc "reload the database with seed data"
	task :seed do
		on primary fetch(:migration_role) do
			within release_path do
				with rails_env: fetch(:rails_env)  do
					execute :rake, 'db:seed'
				end
			end
		end
	end

	desc 'Clear memcache'
    task :clear_memcache do
      on roles(:app) , in: :sequence, wait: 2 do
        Rails.cache.clear
        CACHE.flush
      end
    end

    before :starting,     :check_revision
    after  :finishing,    :compile_assets
    after  :finishing,    :cleanup
    after  :finishing,    :copy_missing_css
    after  :finishing,    :clear_cache
    after  :finishing,    :clear_memcache
    after  :finishing,    :restart
end