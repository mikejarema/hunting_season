require 'rspec/expectations'

# IMPORTANT
# When matching against the ACTUAL API we don't check for the exact ETAG value
# but rather that it matches the general ETAG format

RSpec::Matchers.define :be_a_producthunt_etag do |expected|
  match do |actual|
    valid_formatting = actual =~ /\A[0-9a-f]{32}\z/

    if RSpec.configuration.use_live_api? || expected.nil?
      valid_formatting
    else
      valid_formatting && actual == expected
    end
  end
end
