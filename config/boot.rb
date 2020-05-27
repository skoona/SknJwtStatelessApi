# ##
# File: ./config/boot.rb
# - Initialize Core Application: SknApp
#

# Instantiate Application
begin
  unless defined?(SknApp)
    require_relative 'environment'        # Minimal
  end

  # Load Main Business App
  require_relative '../mains/mains'

rescue LoadError, StandardError => ex
  $stderr.puts ex.message
  $stderr.puts ex.backtrace[0..8]
  exit 1
end

