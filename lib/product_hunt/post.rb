module ProductHunt
  class Post
    include Entity

    def created_at
      Time.parse(self["created_at"])
    end

    def day
      Time.parse(self["day"]).to_date
    end

    def votes(options = {})
      if options != @votes_options
        @votes = @client.votes_for_post(self["id"], options)
        @votes_options = options
      end
      @votes
    end

    def comments(options = {})
      if options != @comments_options
        @comments = @client.comments_for_post(self["id"], options)
        @comments_options = options
      end
      @comments
    end
  end
end

