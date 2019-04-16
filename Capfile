# Load DSL and Setup Up Stages
require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/rvm'
require 'capistrano/puma'
require "capistrano/scm/git"
require 'capistrano/rake'
require 'capistrano/chewy'
install_plugin Capistrano::Puma
install_plugin Capistrano::SCM::Git
install_plugin Capistrano::Puma::Nginx  # if you want to upload a nginx site template

set :rvm_type, :user
set :rvm_ruby_version, '2.6.0'
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }