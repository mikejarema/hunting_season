require 'bundler/setup'
Bundler.setup

require 'hunting_season'

RSpec.configure do |config|

  # By default we're stubbing out the web requests to api.producthunt.com, but
  # SKIP_CALL_STUBS=true allows these calls to pass through to the actual API
  if ENV['SKIP_CALL_STUBS'].is_a?(String) && ['true', '1', 'yes', 'indubitably'].include?(ENV['SKIP_CALL_STUBS'].downcase)
    def stub_request(*args)
      double(Object, to_return: nil) # this will gobble up calls to stub_request(method, url).to_return(data)
    end
  else
    require 'webmock/rspec'
  end

end
