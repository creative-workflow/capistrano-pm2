# Capistrano::pm2 [![Gem Version](https://badge.fury.io/rb/capistrano-pm2.svg)](http://badge.fury.io/rb/capistrano-pm2)

nodejs [pm2](https://github.com/Unitech/pm2) support for Capistrano 3.x

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano', '~> 3.1.0'
gem 'capistrano-pm2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-pm2

## Usage

Require in `Capfile` to use the default task:

```ruby
require 'capistrano/pm2'
```

Available Tasks
```ruby
cap pm2:delete                     # Delete pm2 application
cap pm2:list                       # Show pm2 application info
cap pm2:logs                       # Watch pm2 logs
cap pm2:reload                     # Reload app gracefully
cap pm2:restart                    # Restart app
cap pm2:setup                      # Install pm2 via npm on the remote host
cap pm2:start                      # Start pm2 application
cap pm2:start_or_reload            # Start or gracefully reload pm2 application
cap pm2:start_or_restart           # Start or restart pm2 application
cap pm2:status                     # List all pm2 applications
cap pm2:stop                       # Stop pm2 application
cap pm2:save                       # Save pm2 state so it can be loaded after restart
```

Configurable options:
```ruby
set :pm2_app_command, 'main.js'                   # the main program
set :pm2_app_name, fetch(:application)            # name for pm2 app
set :pm2_target_path, -> { release_path }         # where to run pm2 commands
set :pm2_roles, :all                              # server roles where pm2 runs on
set :pm2_env_variables, {}                        # default: env vars for pm2
set :pm2_config_path, ''                          # pm2 ecosystem file path
set :pm2_options, -> { "--cwd #{fetch(:current_path)} --name #{fetch(:application)}" } # options for pm2 CLI
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
