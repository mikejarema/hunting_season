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
      elsif options_or_id_or_nil.nil?
        Post.where(self, {})
      elsif options_or_id_or_nil.is_a?(Hash)
        Post.where(self, options_or_id_or_nil)
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

    class InvalidArgumentError < ArgumentError; end
    class InvalidCallError < RuntimeError; end
  end
end
