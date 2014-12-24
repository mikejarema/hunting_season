module ProductHunt
  module Entity

    def initialize(attributes, client)
      @attributes = attributes
      @client = client
    end

    def [](key)
      @attributes[key]
    end

  end
end
