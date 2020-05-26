require File.expand_path '../src/main.rb', __FILE__
run Rack::URLMap.new({'/' => JwtAuthenticator, '/api/v1' => JwtStatelessApi})
