require 'capistrano_colors'

set :application, "plague"
set :repository,  "git@github.com:ai/plague.git"
set :scm, :git

set :deploy_to, "/home/ai/#{application}"
set :domain,    "insomnis.ru"

set :use_sudo, false
set :normalize_asset_timestamps, false

role :app, domain
role :web, domain

namespace :deploy do
  task :symlink_configs do
    run "ln -s #{shared_path}/config/* #{release_path}/config/"
  end
end

before "deploy:assets:precompile", "deploy:symlink_configs"

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
set :rvm_ruby_string, 'default'

require 'bundler/capistrano'
require 'capistrano-unicorn'

require './config/boot'
require 'airbrake/capistrano'
