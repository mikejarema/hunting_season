module ProductHunt
  module API
    module CurrentUser

      PATH = "/me"

      def me(options = {})
        user = fetch(PATH, options)
        User.new(user["user"], self) if user.code == 200
      end

    end
  end
end
