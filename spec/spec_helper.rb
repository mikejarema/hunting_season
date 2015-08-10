require 'bundler/setup'
Bundler.setup

require 'hunting_season'

Dir[File.dirname(__FILE__) + "/support/matchers/*.rb"].each do |path|
  require File.join(path) if path !~ /_spec\.rb\z/
end

TIMESTAMP_FORMAT = '%FT%T.%L%:z'
DATESTAMP_FORMAT = '%F'

RSpec.configure do |config|

  # By default we're stubbing out the web requests to api.producthunt.com, but
  # USE_LIVE_API=true allows these calls to pass through to the actual API
  config.define_singleton_method(:use_live_api?) do
    ENV['USE_LIVE_API'].is_a?(String) && ['true', '1', 'yes', 'indubitably'].include?(ENV['USE_LIVE_API'].downcase)
  end

  if config.use_live_api?
    def stub_request(*args)
      # this will gobble up calls to stub_request(method, url).with(something)to_return(data)
      obj = Object.new
      obj.define_singleton_method(:to_return) { |*args| nil }
      obj.define_singleton_method(:with)      { |*args| obj }
      obj
    end
  else
    require 'webmock/rspec'
    ENV['TOKEN'] ||= "dummy-token-to-ensure-specs-run"
  end

end
