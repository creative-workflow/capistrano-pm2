namespace :pm2 do
  after 'deploy:publishing', 'pm2:start_or_reload'

  desc 'List all pm2 applications'
  task :status do
    run_task :pm2, :list
  end

  desc 'Start pm2 application'
  task :start do
    run_task :pm2, :start, script_or_config, fetch(:pm2_options)
  end

  desc 'Restart pm2 application'
  task :restart do
    run_task :pm2, :restart, script_or_config, fetch(:pm2_options)
  end

  desc 'Reload pm2 application'
  task :reload do
    run_task :pm2, :reload, app_name, fetch(:pm2_options)
  end

  desc 'Start or restart pm2 application'
  task :start_or_restart do
    run_task :pm2, :startOrRestart, fetch(:pm2_config_path), fetch(:pm2_options)
  end

  desc 'Start or gracefully reload pm2 application'
  task :start_or_reload do
    run_task :pm2, :startOrReload, fetch(:pm2_config_path), fetch(:pm2_options)
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

  def script_or_config
    if fetch(:pm2_config_path).empty?
      fetch(:pm2_app_command)
    else
      fetch(:pm2_config_path)
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
    set :pm2_config_path, ''
    set :pm2_options, -> {
      fetch(:pm2_config_path).empty? ? "--cwd #{current_path} --name #{app_name}" : ''
    }
    set :pm2_roles, :all
    set :pm2_env_variables, {}
  end
end
