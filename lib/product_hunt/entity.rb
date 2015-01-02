module ProductHunt
  module Entity

    def initialize(attributes, client)
      @attributes = attributes
      @client = client
    end

    def [](key)
      @attributes[key]
    end

    def user
      if @client.is_a?(Client) && @attributes['user'].is_a?(Hash) && @attributes['user']['id']
        @client.user(@attributes['user']['id'])
      else
        raise_no_method_error('user')
      end
    end

    def post
      if @client.is_a?(Client) && @attributes['post_id']
        @client.post(@attributes['post_id'])
      else
        raise_no_method_error('post')
      end
    end

  private

    def raise_no_method_error(method)
      raise NoMethodError.new("undefined method `#{method}' for #{self.inspect}:#{self.class.name}")
    end

  end
end
