# config valid for current version and patch releases of Capistrano
lock "~> 3.17.2"

set :application, "share-video"
set :repo_url, "git@github.com:quangminhvo79/minhvo_demo.git"
set :user, "ubuntu"
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :use_sudo, false
set :branch, 'develop'
set :rails_env, 'production'

set :pty, true
set :initial, true
# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'
set :linked_files, %w{config/master.key config/credentials.yml.enc}

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/sockets", "tmp/webpacker", "public/system", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 2

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
set :puma_threads,    [4, 16]
set :puma_workers,    0

set :deploy_via,      :remote_cache
set :puma_user,       fetch(:user)
set :puma_rackup, -> { File.join(current_path, 'config.ru') }

set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log,  "#{release_path}/log/puma.error.log"

set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord
  # append :rbenv_map_bins, 'puma', 'pumactl'

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

before 'deploy:starting', 'config_files:upload'
before 'deploy:migrate', 'database:create' if fetch(:initial)
before "deploy:assets:precompile", "deploy:yarn_install"

namespace :deploy do
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        unless test("[ -f #{shared_path}/config/master.key ]")
          upload! 'config/master.key', "#{shared_path}/config/master.key"
        end
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

  desc "Run rake yarn:install"
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install --silent --no-progress --no-audit --no-optional")
      end
    end
  end
end
