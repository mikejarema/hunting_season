# TODO: factor out a base class btw User and Post

require 'httparty'
require 'uri'

module ProductHunt
  class API
    include HTTParty
    base_uri 'https://api.producthunt.com/v1/'
    format :json

    def initialize(token)
      @config = { headers: { "Authorization" => "Bearer #{token}" } }
    end

    def config
      @config
    end

    def posts(options_or_id_or_nil = nil)
      if options_or_id_or_nil.is_a?(Fixnum)
        post = Post.new(self, options_or_id_or_nil)
      else
        raise InvalidArgumentError.new("#{options_or_id_or_nil} is not supported by ProductHunt::API#posts")
      end
    end

    def users(id)
      if id.is_a?(Fixnum) || id.is_a?(String)
        post = User.new(self, id)
      else
        raise InvalidArgumentError.new("#{id} is not supported by ProductHunt::API#users")
      end
    end

    class User
      def initialize(api, id_or_username)
        @api = api
        @id_or_username = id_or_username
        @attributes = nil
        self
      end

      def [](key)
        if @attributes.nil?
          fetch_self
        end
        @attributes[key]
      end

    private

      def fetch_self
        @attributes = @api.class.get("/users/#{@id_or_username}", @api.config)["user"]
      end

    end

    class Post
      def initialize(api, id)
        @api = api
        @id = id
        @attributes = nil
        self
      end

      def [](key)
        if @attributes.nil?
          fetch_self
        end
        @attributes[key]
      end

      def votes(options = {})
        if @id
          fetch_votes(options).map{|i| Vote.new(@api, i)}
        else
          raise InvalidCallError.new("Cannot call ProductHunt::Post#votes on an unsaved or uninitialized Post")
        end
      end

      def comments(options = {})
        if @id
          fetch_comments(options).map{|i| Comment.new(@api, i)}
        else
          raise InvalidCallError.new("Cannot call ProductHunt::Post#votes on an unsaved or uninitialized Post")
        end
      end

    private

      def fetch_self
        @attributes = @api.class.get("/posts/#{@id}", @api.config)["post"]
      end

      def fetch_votes(params)
        path = "/posts/#{@id}/votes"
        if params.is_a?(Enumerable)
          path += "?" + URI.encode_www_form(params)
        end
        @api.class.get(path, @api.config)["votes"]
      end

      def fetch_comments(params)
        path = "/posts/#{@id}/comments"
        if params.is_a?(Enumerable)
          path += "?" + URI.encode_www_form(params)
        end
        @api.class.get(path, @api.config)["comments"]
      end

    end

    class Vote
      def initialize(api, attributes)
        @attributes = attributes
      end

      def [](key)
        @attributes[key]
      end
    end

    class Comment
      def initialize(api, attributes)
        @attributes = attributes
      end

      def [](key)
        @attributes[key]
      end
    end

    class InvalidArgumentError < ArgumentError; end
    class InvalidCallError < RuntimeError; end
  end
end
