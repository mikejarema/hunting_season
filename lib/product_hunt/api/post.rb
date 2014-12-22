module ProductHunt
  class API::Post

    def initialize(api, id_or_attributes)
      @api = api

      if id_or_attributes.is_a?(Hash)
        @id = id_or_attributes["id"]
        @attributes = id_or_attributes
      else
        @id = id_or_attributes
        @attributes = nil
      end

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
        fetch_votes(options).map{|i| API::Vote.new(@api, i)}
      else
        raise InvalidCallError.new("Cannot call ProductHunt::Post#votes on an unsaved or uninitialized Post")
      end
    end

    def comments(options = {})
      if @id
        fetch_comments(options).map{|i| API::Comment.new(@api, i)}
      else
        raise InvalidCallError.new("Cannot call ProductHunt::Post#votes on an unsaved or uninitialized Post")
      end
    end

    def self.where(api, options)
      self.fetch_posts(api, options).map{|i| API::Post.new(api, i)}
    end

  private

    def fetch_self
      @attributes = @api.class.get("/posts/#{@id}", @api.config)["post"]
    end

    def self.fetch_posts(api, params)
      path = "/posts"
      if params.is_a?(Enumerable)
        path += "?" + URI.encode_www_form(params)
      end
      api.class.get(path, api.config)["posts"]
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
end
