module ProductHunt
  class API::User
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
end
