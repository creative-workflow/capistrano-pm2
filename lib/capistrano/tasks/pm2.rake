require 'json'

namespace :pm2 do

  desc 'Restart app gracefully'
  task :restart do
    case app_status
    when nil
      info 'App is not registerd'
      invoke 'pm2:start'
    when 'stopped'
      info 'App is stopped'
      restart_app
    when 'errored'
      info 'App has errored'
      restart_app
    when 'online'
      info 'App is online'
      restart_app
    end
  end
  before 'deploy:restart', 'pm2:restart'

  desc 'Show pm2 status'
  task :status do
    run_task :pm2, :status
  end

  desc 'Start pm2 application'
  task :start do
    run_task :pm2, :start, fetch(:pm2_app_command)
  end

  desc 'Stop pm2 application'
  task :stop do
    run_task :pm2, :stop, pm2_app_name
  end

  desc 'Delete pm2 application'
  task :delete do
    run_task :pm2, :delete, pm2_app_name
  end

  desc 'Show pm2 application info'
  task :show do
    run_task :pm2, :show, pm2_app_name
  end

  def run_task(*args)
    on roles fetch(:pm2_roles) do
      within fetch(:pm2_target_path, release_path) do
        with fetch(:pm2_env_variables) do
          execute *args
        end
      end
    end
  end

  def app_status
    within current_path do
      ps = JSON.parse(capture :pm2, :jlist, fetch(:pm2_app_command))

      return nil if ps.empty?

      # status: online, errored, stopped
      return ps[0]["pm2_env"]["status"]
    end
  end

  def restart_app
    run_task :pm2, :restart, pm2_app_name
  end

  def pm2_app_name
    fetch(:pm2_app_command).split('/').last.sub(/\.js$/, '')
  end
end

namespace :load do
  task :defaults do
    set :pm2_app_command, 'main.js'
    set :pm2_roles, :all
    set :pm2_env_variables, {}
  end
end
