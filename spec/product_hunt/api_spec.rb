require 'spec_helper'

describe ProductHunt do

  TIMESTAMP_FORMAT = '%FT%T.%L%:z'
  DATESTAMP_FORMAT = '%F'

  before(:each) do
    @client = ProductHunt::Client.new(ENV['TOKEN'] || 'my-token')
  end

  describe 'API' do

    it 'requires a valid API token (eg. env TOKEN=mytoken bundle exec rake)' do
      expect(ENV["TOKEN"]).to_not be_nil
    end

    describe 'Client' do

      it 'stores last ETAG value' do
        stub_request(:get, "https://api.producthunt.com/v1/posts").
          to_return( lambda { |request|
            File.new("./spec/support/index_response.txt").read.
              gsub(/POST_TIMESTAMP/, (Time.now - 86400).strftime(TIMESTAMP_FORMAT)).
              gsub(/POST_DATESTAMP/, (Time.now - 86400).strftime(DATESTAMP_FORMAT))
          })

        posts = @client.posts

        expect(@client.last_etag).to eq '"b45b3ee1d10ba50fae6bbc6d9fb79a88"'
      end

      it 'allows to pass custom headers' do
        stub_request(:get, "https://api.producthunt.com/v1/posts").
          with(headers: { 'If-None-Match' => '"c9ab3ee1d10ba50fae6bbc6d9fb79a2a"' }).
          to_return( lambda { |request|
            File.new("./spec/support/index_response.txt").read.
              gsub(/POST_TIMESTAMP/, (Time.now - 86400).strftime(TIMESTAMP_FORMAT)).
              gsub(/POST_DATESTAMP/, (Time.now - 86400).strftime(DATESTAMP_FORMAT))
          })

        posts = @client.posts( headers: { 'If-None-Match' => '"c9ab3ee1d10ba50fae6bbc6d9fb79a2a"' })

        expect(@client.last_etag).to eq '"b45b3ee1d10ba50fae6bbc6d9fb79a88"'
      end

    end

    describe 'Posts' do

      it 'implements posts#index and yields the hunts for today' do
        stub_request(:get, "https://api.producthunt.com/v1/posts").
          to_return(lambda { |request|
            File.new("./spec/support/index_response.txt").read.
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
            File.new("./spec/support/index_with_10day_param_response.txt").read.
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

      describe 'by id' do

        before(:each) do
          stub_request(:get, "https://api.producthunt.com/v1/posts/3372").
            to_return(File.new("./spec/support/get_post.txt"))

          @post = @client.post(3372)
        end

        it 'implements posts#show and yields the name of the post' do
          expect(@post['name']).to eq('namevine')
        end

        describe 'associated objects' do

          it 'should return a User object when #user is called' do
            stub_request(:get, "https://api.producthunt.com/v1/users/962").
              to_return(File.new("./spec/support/get_user_962.txt"))

            user = @post.user
            expect(user["id"]).to eq(@post["user"]["id"])
            expect(user["name"]).to eq(@post["user"]["name"])
          end

        end

        describe 'Votes' do

          before(:each) do
            stub_request(:get, "https://api.producthunt.com/v1/posts/3372").
              to_return(File.new("./spec/support/get_post.txt"))

            @post = @client.post(3372)
          end

          it 'implements votes#index and yields the first voter' do
            stub_request(:get, "https://api.producthunt.com/v1/posts/3372/votes?order=asc").
              to_return(File.new("./spec/support/get_post_votes.txt"))

            vote = @post.votes(order: 'asc').first

            expect(vote).to be_a(ProductHunt::Vote)
            expect(vote['user']['username']).to eq('_jacksmith')
          end

          it 'implements votes#index with pagination' do
            stub_request(:get, "https://api.producthunt.com/v1/posts/3372/votes?per_page=1&order=asc").
              to_return(File.new("./spec/support/get_post_votes_per_page.txt"))

            votes = @post.votes(per_page: 1, order: 'asc')
            expect(votes.size).to be(1)

            stub_request(:get, "https://api.producthunt.com/v1/posts/3372/votes?newer=46164&per_page=1&order=asc").
              to_return(File.new("./spec/support/get_post_votes_per_page_newer.txt"))

            votes = @post.votes(per_page: 1, order: 'asc', newer: votes.first['id'])
            expect(votes.size).to be(1)
            expect(votes.first['user']['username']).to eq('rrhoover')
          end

          describe 'associated objects' do

            before(:each) do
              stub_request(:get, "https://api.producthunt.com/v1/posts/3372/votes").
                to_return(File.new("./spec/support/get_post_votes.txt"))
              stub_request(:get, "https://api.producthunt.com/v1/users/962").
                to_return(File.new("./spec/support/get_user_962.txt"))

              @vote = @post.votes.first
            end

            it 'should return a User object when #user is called' do
              stub_request(:get, "https://api.producthunt.com/v1/users/98237").
                to_return(File.new("./spec/support/get_user_98237.txt"))

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
              to_return(File.new("./spec/support/comments_index.txt"))

            comment = @post.comments(order: 'asc').first

            expect(comment).to be_a(ProductHunt::Comment)
            expect(comment['user']['username']).to eq('andreasklinger')
          end

          it 'implements comments#index with pagination' do
            stub_request(:get, "https://api.producthunt.com/v1/posts/3372/comments?order=asc&per_page=1").
              to_return(File.new("./spec/support/comments_index_per_page.txt"))

            comments = @post.comments(per_page: 1, order: 'asc')
            expect(comments.size).to be(1)

            stub_request(:get, "https://api.producthunt.com/v1/posts/3372/comments?per_page=1&order=asc&newer=11378").
              to_return(File.new("./spec/support/comments_index_per_page_newer.txt"))

            comments = @post.comments(per_page: 1, order: 'asc', newer: comments.first['id'])
            expect(comments.size).to be(1)
            expect(comments.first['user']['username']).to eq('dshan')
          end

          describe 'associated objects' do

            before(:each) do
              stub_request(:get, "https://api.producthunt.com/v1/posts/3372/comments?order=asc").
                to_return(File.new("./spec/support/comments_index.txt"))

              @comment = @post.comments(order: 'asc').first
            end

            it 'should return a User object when #user is called' do
              stub_request(:get, "https://api.producthunt.com/v1/users/4557").
                to_return(File.new("./spec/support/get_user_4557.txt"))

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

    describe 'Users' do

      it 'implements users#show and yields the details of a specific user' do
        stub_request(:get, "https://api.producthunt.com/v1/users/rrhoover").
          to_return(File.new("./spec/support/get_user.txt"))

        user = @client.user('rrhoover')

        expect(user['name']).to eq('Ryan Hoover')
        expect(user['id']).to eq(2)
      end

    end

    describe 'Entity' do

      before(:each) do
        stub_request(:get, "https://api.producthunt.com/v1/users/rrhoover").
          to_return(File.new("./spec/support/get_user.txt"))

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
