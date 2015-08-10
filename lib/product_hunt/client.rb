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

    def fetch(path, params)
      config = @config

      if params.has_key?(:headers)
        headers = params.delete(:headers)
        config = config.merge({headers: config[:headers].merge(headers)})
      end

      queryopts = if params.is_a?(Enumerable) && params.size > 0
        "?" + URI.encode_www_form(params)
      end

      self.class.get(path + (queryopts || ""), config)
    end

    def process(path, params)
      response = fetch(path, params)

      if response.code == 200 && block_given?
        processed_response = yield response
      else
        fail "Still need to cover the other response codes and use cases for the API (eg. 304 not modified, error cases)"
      end

      if response.headers["etag"]
        fail "Object already defines #etag method" if processed_response.respond_to?(:etag)
        processed_response.define_singleton_method(:etag) { response.headers["etag"] }
      end

      processed_response
    end
  end
end
