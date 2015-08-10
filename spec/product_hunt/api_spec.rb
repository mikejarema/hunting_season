require 'spec_helper'

describe ProductHunt do

  before(:all) do
    @client = ProductHunt::Client.new(ENV['TOKEN'] || 'my-token')
  end

  describe 'API' do

    it 'requires a valid API token (eg. env TOKEN=mytoken bundle exec rake)' do
      expect(ENV["TOKEN"]).to_not be_nil
    end

    describe 'Entity' do

      before(:each) do
        stub_request(:get, "https://api.producthunt.com/v1/users/rrhoover").
          to_return(File.new("./spec/support/webmocks/get_user.txt"))

        @user_entity_without_associated_post_or_user = @client.user('rrhoover')
      end

      it 'should not attempt to instantiate a Post where its attributes do not imply one' do
        expect { @user_entity_without_associated_post_or_user.post }.to raise_error(NoMethodError)
      end

      it 'should not attempt to instantiate a User where its attributes do not imply one' do
        expect { @user_entity_without_associated_post_or_user.user }.to raise_error(NoMethodError)
      end

    end

  end

end
