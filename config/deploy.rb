load 'deploy/assets'
require 'bundler/capistrano'

set :stages, %w(staging)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

set :user,        "fulcrum"
set :application, "fulcrum"
set :domain,      "fulcrum.9elements.com"
set :repository,  "ssh://git@gitlab.9elements.com:23222/sebastian.deutsch/fulcrum.git"
set :use_sudo,    false
set :normalize_asset_timestamps, false

ssh_options[:forward_agent] = true
set :scm, :git
set :deploy_via, :remote_cache
set :git_enable_submodules, 0

role :app, domain
role :web, domain
role :db,  domain, :primary => true

set :default_environment, {
  'PATH' => '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH',
  'RBENV_ROOT' => "/usr/local/rbenv"
}

namespace :deploy do
  task(:stop,    :roles => :app) {}
  task(:restart, :roles => :app, :except => { :no_release => true }) {
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  }
  task(:start, :roles => :app, :except => { :no_release => true }) {
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  }
  desc "Show deployed revision on server"
  task(:show_revision, :roles => :app) {
    run "cat #{File.join(current_path,'REVISION')}"
  }
end
