require 'httparty'
require 'uri'

module ProductHunt
  class Client
    include HTTParty
    base_uri 'https://api.producthunt.com/v1/'
    format :json
    attr_reader :config, :last_etag

    include ProductHunt::API

    def initialize(token)
      @config = { headers: { "Authorization" => "Bearer #{token}" } }
    end

    def fetch(path, params)
      headers = params.has_key?(:headers) ? params.delete(:headers) : {}
      queryopts = if params.is_a?(Enumerable) && params.size > 0
        "?" + URI.encode_www_form(params)
      end

      request_config = config.dup
      request_config[ :headers ] = request_config[ :headers ].merge(headers)

      response = self.class.get(path + (queryopts || ""), request_config)
      @last_etag = response.headers['etag']
      response
    end
  end
end
