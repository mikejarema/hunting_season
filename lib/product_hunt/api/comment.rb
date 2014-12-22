module ProductHunt

  class API::Comment
    def initialize(api, attributes)
      @attributes = attributes
    end

    def [](key)
      @attributes[key]
    end
  end

end
