require 'spec_helper'

describe ProductHunt do

  before(:each) do
    @api = ProductHunt::API.new(ENV['TOKEN'] || 'my-token')
  end

  describe 'API::Post' do

    before(:each) do
      @post = @api.posts(3372)
    end

    it 'implements posts#show and yields the name of the post' do
      @post['name'].should == 'namevine'
    end

    it 'implements votes#index and yields the first voter' do
      vote = @post.votes.first

      vote.should be_a(ProductHunt::API::Vote)
      vote['user']['username'].should == '1korda'
    end

    it 'implements votes#index with pagination' do
      votes = @post.votes(per_page: 1)
      votes.size.should be(1)

      votes = @post.votes(per_page: 1, older: votes.first['id'])
      votes.size.should be(1)
      votes.first['user']['username'].should == 'mikejarema'
    end

  end

end
