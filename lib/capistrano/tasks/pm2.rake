require 'json'

namespace :pm2 do
  desc 'Restart app gracefully'
  task :restart do
    on roles fetch(:pm2_roles) do
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
  end

  before 'deploy:restart', 'pm2:restart'

  desc 'List all pm2 applications'
  task :status do
    run_task :pm2, :list
  end

  desc 'Start pm2 application'
  task :start do
    run_task :pm2, :start, fetch(:pm2_app_command), "--name #{app_name} #{fetch(:pm2_start_params)}"
  end

  desc 'Stop pm2 application'
  task :stop do
    run_task :pm2, :stop, app_name
  end

  desc 'Delete pm2 application'
  task :delete do
    run_task :pm2, :delete, app_name
  end

  desc 'Show pm2 application info'
  task :list do
    run_task :pm2, :show, app_name
  end

  desc 'Watch pm2 logs'
  task :logs do
    run_task :pm2, :logs
  end

  desc 'Save pm2 state so it can be loaded after restart'
  task :save do
    run_task :pm2, :save
  end

  desc 'Install pm2 via npm on the remote host'
  task :setup do
    run_task :npm, :install,  'pm2 -g'
  end

  def app_name
    fetch(:pm2_app_name) || fetch(:application)
  end

  def app_status
    within release_path do
      ps = JSON.parse(capture :pm2, :jlist, :'-s')

      # find the process with our app name
      ps.each do |child|
        if child['name'] == app_name
          # status: online, errored, stopped
          return child['pm2_env']['status']
        end
      end

      return nil
    end
  end

  def restart_app
    within release_path do
      execute :pm2, :restart, app_name
    end
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
end

namespace :load do
  task :defaults do
    set :pm2_app_command, 'main.js'
    set :pm2_app_name, nil
    set :pm2_start_params, ''
    set :pm2_roles, :all
    set :pm2_env_variables, {}
  end
end
