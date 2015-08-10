require 'spec_helper'

describe "Custom be_a_producthunt_etag matcher" do

  describe "ac1f85507d81cf40699add4458528b31" do
    if RSpec.configuration.use_live_api? # See IMPORTANT note in implementation of matcher
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
