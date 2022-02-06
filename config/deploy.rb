lock '3.16.0'
set :application, 'look-back'
set :repo_url, 'git@github.com:28niwa2108/look-back.git'
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads', 'public/assets')
set :rbenv_type, :user
set :rbenv_ruby, '2.7.4'

set :ssh_options, auth_methods: ['publickey'],
                                  keys: ['~/.ssh/220113Plb2221.pem'] 

set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }
set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }
set :keep_releases, 5

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end