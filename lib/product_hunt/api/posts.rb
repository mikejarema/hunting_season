module ProductHunt
  module API
    module Posts

      PATH = "/posts"

      def posts(options = {})
        response = fetch(PATH, options)
        response["posts"].map{ |post| Post.new(post, self) } if response.code == 200
      end

      def post(id, options = {})
        post = fetch(PATH + "/#{id}", options)
        Post.new(post["post"], self) if post.code == 200
      end

      def comments_for_post(id, options = {})
        response = fetch(PATH + "/#{id}/comments", options)
        response["comments"].map{ |c| Comment.new(c, self) } if response.code == 200
      end

      def votes_for_post(id, options = {})
        response = fetch(PATH + "/#{id}/votes", options)
        response["votes"].map{ |c| Vote.new(c, self) } if response.code == 200
      end
    end
  end
end
