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
      @votes ||= @client.votes_for_post(self["id"], options)
    end

    def comments(options = {})
      @comments ||= @client.comments_for_post(self["id"], options)
    end
  end
end

