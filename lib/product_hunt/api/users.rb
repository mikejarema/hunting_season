module ProductHunt
  module API
    module Users

      PATH = "/users"

      def user(id, options = {})
        user = fetch(PATH + "/#{id}", options)
        User.new(user["user"], self) if user.code == 200
      end

    end
  end
end
