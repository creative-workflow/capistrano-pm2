# config valid only for current version of Capistrano
lock "3.7.1"

set :application, "pm2-test"

server 'localhost', user: 'travis', password: 'travis', roles: %w{web}
