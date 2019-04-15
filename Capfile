require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rails'
require 'capistrano/rvm'
require 'capistrano/bundler'
# require 'capistrano/puma'
require 'capistrano/scm/git'
require 'capistrano/rails/console'

# set :rbenv_type, :user
set :rvm__type, :user
set :rvm_ruby_version, '2.6.0'
# set :rbenv_ruby, '2.6.0'


set :chewy_conditionally_reset, false    # Reset only modified Chewy indexes, true by default
set :chewy_path, 'app/my_indexes'        # Path to Chewy indexes, 'app/chewy' by default
set :chewy_env, :chewy_production        # Environment variable for Chewy, equal to RAILS_ENV by default
set :chewy_role, :web                    # Chewy role, :app by default  
set :chewy_default_hooks, false          # Add default gem hooks to project deploy flow, true by default
set :chewy_delete_removed_indexes, false # Delete indexes which files have been deleted, true by default

# Load the SCM plugin appropriate to your project:
#
# require "capistrano/scm/hg"
# install_plugin Capistrano::SCM::Hg
# or
# require "capistrano/scm/svn"
# install_plugin Capistrano::SCM::Svn
# or
require "capistrano/scm/git"
# install_plugin Capistrano::Puma
install_plugin Capistrano::SCM::Git

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
# require "capistrano/rvm"
# require "capistrano/rbenv"
# require "capistrano/chruby"
# require "capistrano/bundler"
# require "capistrano/rails/assets"
# require "capistrano/rails/migrations"
# require "capistrano/passenger"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
