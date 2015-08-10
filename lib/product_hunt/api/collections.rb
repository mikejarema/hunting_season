module ProductHunt
  module API
    module Collections

      PATH = "/collections"

      def collections(options = {})
        fetch(PATH, options)["collections"].map{ |collection| Collection.new(collection, self) }
      end

      # def post(id, options = {})
      #   post = fetch(PATH + "/#{id}", options)["post"]
      #   Post.new(post, self)
      # end

      # def comments_for_post(id, options = {})
      #   fetch(PATH + "/#{id}/comments", options)["comments"].map{ |c| Comment.new(c, self) }
      # end

      # def votes_for_post(id, options = {})
      #   fetch(PATH + "/#{id}/votes", options)["votes"].map{ |c| Vote.new(c, self) }
      # end
    end
  end
end
