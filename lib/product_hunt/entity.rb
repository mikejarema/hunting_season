module ProductHunt
  module Entity

    def initialize(attributes, client)
      @attributes = attributes
      @client = client
    end

    def [](key)
      @attributes[key]
    end

    [:user, :post].each do |method|
      eval <<-GENERATED_METHOD
        def #{method}
          if @client.is_a?(Client) && @attributes['#{method}'].is_a?(Hash) && @attributes['#{method}']['id']
            @client.send('#{method}', @attributes['#{method}']['id'])
          elsif @client.is_a?(Client) && @attributes['#{method}_id']
            @client.send('#{method}', @attributes['#{method}_id'])
          else
            raise NoMethodError.new("undefined method `#{method}' for " + self.inspect)
          end
        end
      GENERATED_METHOD
    end

  end
end
