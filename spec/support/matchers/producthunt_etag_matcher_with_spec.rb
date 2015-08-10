require 'spec_helper'
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

describe "Custom be_a_producthunt_etag matcher" do
  # See IMPORTANT note above
  describe "ac1f85507d81cf40699add4458528b31" do
    if RSpec.configuration.use_live_api?
      it {should be_a_producthunt_etag("ac1f85507d81cf40699add4458528b32")}
    else
      it {should_not be_a_producthunt_etag("ac1f85507d81cf40699add4458528b32")}
    end
  end

  describe "ac1f85507d81cf40699add4458528b32" do
    it {should be_a_producthunt_etag("ac1f85507d81cf40699add4458528b32")}
  end

  describe "hello" do
    it {should_not be_a_producthunt_etag}
  end
end
