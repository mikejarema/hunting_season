module ProductHunt
  module API
    module Users

      PATH = "/users"

      def user(id, options = {})
        user = fetch(PATH + "/#{id}", options)["user"]
        User.new(user, self)
      end

    end
  end
end
