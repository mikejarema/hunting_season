require 'spec_helper'

describe "Collections API" do

  before(:all) do
    @client = ProductHunt::Client.new(ENV['TOKEN'] || 'my-token')
  end

  describe 'Collections' do

    it 'implements users#index' do
      raise "Waiting on https://github.com/producthunt/producthunt-api/issues/67"
      # stub_request(:get, "https://api.producthunt.com/v1/collections?order=asc").
      #   to_return(File.new("./spec/support/webmocks/get_collections.txt"))
      #
      # user = @client.collections(order: 'asc', sort_by: 'created_at').first
      #
      # expect(user['name']).to eq('Something')
      # expect(user['id']).to eq(1)
    end

  end

end
