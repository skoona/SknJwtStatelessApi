#!/usr/bin/env puma

# config/puma.rb

directory '.'
rackup 'config.ru'
environment ENV.fetch('RACK_ENV', 'development')
daemonize false
pidfile 'tmp/puma.pid'
state_path 'tmp/puma.state'
threads 2, 16
bind "tcp://0.0.0.0:#{ENV.fetch('RACK_PORT', 8585 ) }"
# stdout_redirect 'tmp/puma.log', 'tmp/puma.log', true
quiet false

on_restart do
  puts 'On restart...'
end
