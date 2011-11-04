require 'capistrano_colors'

set :application, "plague"
set :repository,  "git@github.com:ai/plague.git"
set :scm, :git

set :deploy_to, "/home/ai/#{application}"
set :domain,    "46.182.27.210"

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

require 'bundler/capistrano'
require 'capistrano-unicorn'
