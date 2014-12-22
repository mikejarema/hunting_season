module ProductHunt

  class API::Vote

    def initialize(api, attributes)
      @attributes = attributes
    end

    def [](key)
      @attributes[key]
    end

  end

end
