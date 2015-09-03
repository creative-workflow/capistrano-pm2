require 'json'

namespace :pm2 do
  def app_status
    within current_path do
      ps = JSON.parse(capture :pm2, :jlist, fetch(:pm2_app_command))

      return nil if ps.empty?

      # status: online, errored, stopped
      return ps[0]["pm2_env"]["status"]
    end
  end

  def restart_app
    within current_path do
      execute :pm2, :restart, app_command_without_js_extension
    end
  end

  def app_command_with_js_extension
    "#{app_command_without_js_extension}.js"
  end

  def app_command_without_js_extension
    fetch(:pm2_app_command).sub(/\.js$/, '')
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

  desc 'Show pm2 status'
  task :status do
    run_task :pm2, :status
  end

  desc 'Start pm2 application'
  task :start do
    run_task :pm2, :start, app_command_with_js_extension
  end


  desc 'Stop pm2 application'
  task :stop do
    run_task :pm2, :stop, app_command_without_js_extension
  end

  desc 'Delete pm2 application'
  task :delete do
    run_task :pm2, :delete, app_command_without_js_extension
  end

  desc 'Show pm2 application info'
  task :show do
    run_task :pm2, :show, app_command_without_js_extension
  end
end

namespace :load do
  task :defaults do
    set :pm2_app_command, 'main'
    set :pm2_roles, :all
    set :pm2_env_variables, {}
  end
end
