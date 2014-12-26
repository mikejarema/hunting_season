require 'httparty'
require 'uri'

module ProductHunt
  class Client
    include HTTParty
    base_uri 'https://api.producthunt.com/v1/'
    format :json

    include ProductHunt::API

    def initialize(token)
      @config = { headers: { "Authorization" => "Bearer #{token}" } }
    end

    def config
      @config
    end

    def fetch(path, params)
      queryopts = if params.is_a?(Enumerable) && params.size > 0
        "?" + URI.encode_www_form(params)
      end

      self.class.get(path + (queryopts || ""), @config)
    end
  end
end
