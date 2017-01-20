require 'json'

namespace :pm2 do
  desc 'Start or gracefully reaload app'
  task :start_or_graceful_reload do
    on roles fetch(:pm2_roles) do
      app_names.each do |app_name|
        run_task :pm2, :startOrGracefulReload, fetch(:pm2_app_command), "--name #{app_name} #{fetch(:pm2_start_params)}"
      end
    end
  end

  desc 'List all pm2 applications'
  task :status do
    run_task :pm2, :list
  end

  desc 'Start pm2 application'
  task :start do
    app_names.each do |app_name|
      run_task :pm2, :start, fetch(:pm2_app_command), "--name #{app_name} #{fetch(:pm2_start_params)}"
    end
  end

  desc 'Stop pm2 application'
  task :stop do
    app_names.each {|app_name| run_task :pm2, :stop, app_name}
  end

  desc 'Delete pm2 application'
  task :delete do
    app_names.each {|app_name| run_task :pm2, :delete, app_name}
  end

  desc 'Show pm2 application info'
  task :list do
    app_names.each {|app_name| run_task :pm2, :show, app_name}
  end

  desc 'Watch pm2 logs'
  task :logs do
    run_task :pm2, :logs
  end

  desc 'Install pm2 via npm on the remote host'
  task :setup do
    run_task :npm, :install,  'pm2 -g'
  end

  def app_names
    fetch(:pm2_app_names) || [app_name]
  end

  def app_name
    fetch(:pm2_app_name) || fetch(:application)
  end

  def restart_app
    within fetch(:pm2_target_path, current_path) do
      app_names.each {|app_name| execute :pm2, :reload, app_name}
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
    set :pm2_app_names, nil
    set :pm2_start_params, ''
    set :pm2_roles, :all
    set :pm2_env_variables, {}
  end
end
