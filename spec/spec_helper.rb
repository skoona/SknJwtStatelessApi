if $LOADED_FEATURES.grep(/spec\/spec_helper\.rb/).any?
  begin
    raise "foo"
  rescue => e
    puts <<-MSG
  ===================================================
  It looks like spec_helper.rb has been loaded
  multiple times. Normalize the require to:

    require "spec/spec_helper"

  Things like File.join and File.expand_path will
  cause it to be loaded multiple times.

  Loaded this time from:

    #{e.backtrace.join("\n    ")}
  ===================================================
    MSG
  end
end

ENV['RACK_ENV'] = 'test'
ENV['JWT_ISSUER'] = 'skoona.net'
ENV['JWT_SECRET'] = 'sknSuperSecrets'

require './config/boot.rb'  # main application with web

require 'rspec'
require 'rspec-roda'
require 'rack/test'

#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.warnings = true
  if config.files_to_run.one?
    config.formatter = :documentation
  else
    config.formatter = :progress  #:html, :textmate, :documentation
  end
  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed
  config.color = true
  config.tty = false

  config.include Rack::Test::Methods

end

def app
  Rack::Builder.new_from_string(IO.read("config.ru")) #.first
end

