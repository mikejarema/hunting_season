require 'spec_helper'

describe "ETAG Support" do

  before(:all) do
    @client = ProductHunt::Client.new(ENV['TOKEN'] || 'my-token')
  end

  it 'should provide an ETAG on API calls' do
    stub_request(:get, "https://api.producthunt.com/v1/posts").
      to_return( lambda { |request|
        File.new("./spec/support/webmocks/index_response.txt").read.
          gsub(/POST_TIMESTAMP/, (Time.now - 86400).strftime(TIMESTAMP_FORMAT)).
          gsub(/POST_DATESTAMP/, (Time.now - 86400).strftime(DATESTAMP_FORMAT))
      })

    posts = @client.posts

    expect(posts.etag).to be_a_producthunt_etag("b45b3ee1d10ba50fae6bbc6d9fb79a88")
  end

  describe "passing ETAG" do
    before(:each) do
      stub_request(:get, "https://api.producthunt.com/v1/posts").
        with(headers: { 'If-None-Match' => 'c9ab3ee1d10ba50fae6bbc6d9fb79a2a' }).
        to_return( lambda { |request|
          File.new("./spec/support/webmocks/index_response.txt").read.
            gsub(/POST_TIMESTAMP/, (Time.now - 86400).strftime(TIMESTAMP_FORMAT)).
            gsub(/POST_DATESTAMP/, (Time.now - 86400).strftime(DATESTAMP_FORMAT))
        })
    end

    it 'should allow passing via custom header' do
      posts = @client.posts(headers: { 'If-None-Match' => 'c9ab3ee1d10ba50fae6bbc6d9fb79a2a' })
      expect(posts.etag).to be_a_producthunt_etag("b45b3ee1d10ba50fae6bbc6d9fb79a88")
    end

    it 'should allow passing via explicit parameter' do
      posts = @client.posts(etag: 'c9ab3ee1d10ba50fae6bbc6d9fb79a2a')
      expect(posts.etag).to be_a_producthunt_etag("b45b3ee1d10ba50fae6bbc6d9fb79a88")
    end
  end

  describe '#modified?' do

    it 'should return true on a modified record' do
      stub_request(:get, "https://api.producthunt.com/v1/posts/3372").
        with(headers: { 'If-None-Match' => 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' }).
        to_return(File.new("./spec/support/webmocks/get_post.txt"))

      @post = @client.post(3372, headers: { 'If-None-Match' => 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' })
      expect(@post).to be_modified
    end

    describe "on an unmodified record" do
      before(:all) do
        stub_request(:get, "https://api.producthunt.com/v1/posts/3372").
          to_return(File.new("./spec/support/webmocks/get_post.txt"))

        stub_request(:get, "https://api.producthunt.com/v1/posts/3372").
          with(headers: { 'If-None-Match' => 'aa5e181357bae02ad58f3cc3552e5b95' }).
          to_return(File.new("./spec/support/webmocks/get_unmodified_post.txt"))

        @post = @client.post(3372)
        @unmodified_post = @client.post(3372, headers: { 'If-None-Match' => @post.etag })
      end


      it 'should return false' do
        expect(@unmodified_post).to_not be_modified
      end

      it 'should throw an exception when trying to access an attribute said record' do
        expect { @unmodified_post["name"] }.to raise_error(ProductHunt::InvalidAccessToUnmodifiedRecordError)
      end
    end

  end

end
