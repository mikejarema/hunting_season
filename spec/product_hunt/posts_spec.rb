require 'spec_helper'

describe "Posts API" do

  before(:all) do
    @client = ProductHunt::Client.new(ENV['TOKEN'] || 'my-token')
  end

  it 'implements posts#index and yields the hunts for today' do
    stub_request(:get, "https://api.producthunt.com/v1/posts").
      to_return(lambda { |request|
        File.new("./spec/support/webmocks/index_response.txt").read.
          gsub(/POST_TIMESTAMP/, (Time.now - 86400).strftime(TIMESTAMP_FORMAT)).
          gsub(/POST_DATESTAMP/, (Time.now - 86400).strftime(DATESTAMP_FORMAT))
      })

    posts = @client.posts
    expect(posts.size).to be > 0

    post = posts.first
    day = post.day

    expect(Time.now.to_date - day).to be <= 1 # either today's or yesterdays
  end

  it 'implements posts#index and yields the hunts for days_ago: 10' do
    stub_request(:get, "https://api.producthunt.com/v1/posts?days_ago=10").
      to_return(lambda { |request|
        File.new("./spec/support/webmocks/index_with_10day_param_response.txt").read.
          gsub(/POST_TIMESTAMP/, (Time.now - 10 * 86400).strftime(TIMESTAMP_FORMAT)).
          gsub(/POST_DATESTAMP/, (Time.now - 10 * 86400).strftime(DATESTAMP_FORMAT))
      })

    posts = @client.posts(days_ago: 10)
    expect(posts.size).to be > 0

    post = posts.first
    day = post.day

    expect(Time.now.to_date - day).to be >= 10 # at least 10 day old and
    expect(Time.now.to_date - day).to be <= 11 # at most 11 days old
  end

  describe 'all posts endpoint' do

    it 'should list the earliest products hunted' do
      stub_request(:get, "https://api.producthunt.com/v1/posts/all?order=asc&newer=0").
        to_return(lambda { |request|
          File.new("./spec/support/webmocks/get_posts_all.txt").read
        })

      posts = @client.all_posts(newer: 0, order: 'asc')

      expect(posts.first["name"]).to eq("Ferro")
      expect(posts.first["tagline"]).to eq("Keyboard interface to Google Chrome")
      expect(posts.first["id"]).to eq(3)
    end

    it 'should search by URL' do
      stub_request(:get, "https://api.producthunt.com/v1/posts/all?search[url]=http://namevine.com").
        to_return(lambda { |request|
          File.new("./spec/support/webmocks/get_posts_all_search.txt").read
        })

      posts = @client.all_posts("search[url]" => 'http://namevine.com')

      expect(posts.first["name"]).to eq("namevine")
      expect(posts.first["tagline"]).to eq("Instantly Find Available Domains & Social Media Profiles")
      expect(posts.first["id"]).to eq(3372)
    end

  end

  describe 'by id' do

    before(:each) do
      stub_request(:get, "https://api.producthunt.com/v1/posts/3372").
        to_return(File.new("./spec/support/webmocks/get_post.txt"))

      @post = @client.post(3372)
    end

    it 'implements posts#show and yields the name of the post' do
      expect(@post['name']).to eq('namevine')
    end

    describe 'associated objects' do

      it 'should return a User object when #user is called' do
        stub_request(:get, "https://api.producthunt.com/v1/users/962").
          to_return(File.new("./spec/support/webmocks/get_user_962.txt"))

        user = @post.user
        expect(user["id"]).to eq(@post["user"]["id"])
        expect(user["name"]).to eq(@post["user"]["name"])
      end

    end

    describe 'Votes' do

      before(:each) do
        stub_request(:get, "https://api.producthunt.com/v1/posts/3372").
          to_return(File.new("./spec/support/webmocks/get_post.txt"))

        @post = @client.post(3372)
      end

      it 'implements votes#index and yields the first voter' do
        stub_request(:get, "https://api.producthunt.com/v1/posts/3372/votes?order=asc").
          to_return(File.new("./spec/support/webmocks/get_post_votes.txt"))

        vote = @post.votes(order: 'asc').first

        expect(vote).to be_a(ProductHunt::Vote)
        expect(vote['user']['username']).to eq('_jacksmith')
      end

      it 'implements votes#index with pagination' do
        stub_request(:get, "https://api.producthunt.com/v1/posts/3372/votes?per_page=1&order=asc").
          to_return(File.new("./spec/support/webmocks/get_post_votes_per_page.txt"))

        votes = @post.votes(per_page: 1, order: 'asc')
        expect(votes.size).to be(1)

        stub_request(:get, "https://api.producthunt.com/v1/posts/3372/votes?newer=46164&per_page=1&order=asc").
          to_return(File.new("./spec/support/webmocks/get_post_votes_per_page_newer.txt"))

        votes = @post.votes(per_page: 1, order: 'asc', newer: votes.first['id'])
        expect(votes.size).to be(1)
        expect(votes.first['user']['username']).to eq('rrhoover')
      end

      describe 'associated objects' do

        before(:each) do
          stub_request(:get, "https://api.producthunt.com/v1/posts/3372/votes").
            to_return(File.new("./spec/support/webmocks/get_post_votes.txt"))
          stub_request(:get, "https://api.producthunt.com/v1/users/962").
            to_return(File.new("./spec/support/webmocks/get_user_962.txt"))

          @vote = @post.votes.first
        end

        it 'should return a User object when #user is called' do
          stub_request(:get, "https://api.producthunt.com/v1/users/98237").
            to_return(File.new("./spec/support/webmocks/get_user_98237.txt"))

          user = @vote.user
          expect(user).to be_a(ProductHunt::User)
          expect(user["id"]).to eq(@vote["user"]["id"])
          expect(user["name"]).to eq(@vote["user"]["name"])
        end

        it 'should return a Post object when #post is called' do
          post = @vote.post
          expect(post).to be_a(ProductHunt::Post)
          expect(post["id"]).to eq(@vote["post_id"])
        end

      end

    end

    describe 'Comments' do
      it 'implements comments#index and yields the first voter' do
        stub_request(:get, "https://api.producthunt.com/v1/posts/3372/comments?order=asc").
          to_return(File.new("./spec/support/webmocks/comments_index.txt"))

        comment = @post.comments(order: 'asc').first

        expect(comment).to be_a(ProductHunt::Comment)
        expect(comment['user']['username']).to eq('andreasklinger')
      end

      it 'implements comments#index with pagination' do
        stub_request(:get, "https://api.producthunt.com/v1/posts/3372/comments?order=asc&per_page=1").
          to_return(File.new("./spec/support/webmocks/comments_index_per_page.txt"))

        comments = @post.comments(per_page: 1, order: 'asc')
        expect(comments.size).to be(1)

        stub_request(:get, "https://api.producthunt.com/v1/posts/3372/comments?per_page=1&order=asc&newer=11378").
          to_return(File.new("./spec/support/webmocks/comments_index_per_page_newer.txt"))

        comments = @post.comments(per_page: 1, order: 'asc', newer: comments.first['id'])
        expect(comments.size).to be(1)
        expect(comments.first['user']['username']).to eq('dshan')
      end

      describe 'associated objects' do

        before(:each) do
          stub_request(:get, "https://api.producthunt.com/v1/posts/3372/comments?order=asc").
            to_return(File.new("./spec/support/webmocks/comments_index.txt"))

          @comment = @post.comments(order: 'asc').first
        end

        it 'should return a User object when #user is called' do
          stub_request(:get, "https://api.producthunt.com/v1/users/4557").
            to_return(File.new("./spec/support/webmocks/get_user_4557.txt"))

          user = @comment.user
          expect(user).to be_a(ProductHunt::User)
          expect(user["id"]).to eq(@comment["user"]["id"])
          expect(user["name"]).to eq(@comment["user"]["name"])
        end

        it 'should return a Post object when #post is called' do
          post = @comment.post
          expect(post).to be_a(ProductHunt::Post)
          expect(post["id"]).to eq(@comment["post_id"])
        end

      end

    end

  end

end
