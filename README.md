# capistrano-pm2 [![Gem Version](https://badge.fury.io/rb/capistrano-pm2.svg)](http://badge.fury.io/rb/capistrano-pm2)
This is a pm2 handler for capistrano 3.x.

# Capistrano::pm2

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

The task will run before `deploy:restart` as part of Capistrano's default deploy,
or can be run in isolation with `cap production pm2:restart`. You can also invoke it in your `deploy.rb`:
```ruby
namespace :deploy do
  desc 'Restart application'
  task :restart do
    # invoke 'npm:install'
    invoke 'pm2:restart'
  end

  after :publishing, :restart
end
```


Available Tasks
```ruby
cap pm2:restart                    # Restart app gracefully
cap pm2:show                       # Show pm2 application info
cap pm2:start                      # Start pm2 application
cap pm2:status                     # Show pm2 status
cap pm2:stop                       # Stop pm2 application
```

Configurable options:

```ruby
set :pm2_app_command, 'main'                      # default, runs main.js
set :pm2_target_path, -> { release_path.join('subdir') } # default not set
set :pm2_roles, :all                              # default
set :pm2_env_variables, {}                        # default
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
