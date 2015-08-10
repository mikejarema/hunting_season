module ProductHunt
  module API
    module Posts

      PATH = "/posts"

      def posts(options = {})
        process(PATH, options) do |response|
          response["posts"].map{ |post| Post.new(post, self) }
        end
      end

      def all(options = {})
        process(PATH + "/all", options) do |response|
          response["posts"].map{ |post| Post.new(post, self) }
        end
      end

      def post(id, options = {})
        process(PATH + "/#{id}", options) do |response|
          Post.new(response["post"], self)
        end
      end

      def comments_for_post(id, options = {})
        process(PATH + "/#{id}/comments", options) do |response|
          response["comments"].map{ |c| Comment.new(c, self) }
        end
      end

      def votes_for_post(id, options = {})
        process(PATH + "/#{id}/votes", options) do |response|
          response["votes"].map{ |c| Vote.new(c, self) }
        end
      end
    end
  end
end
