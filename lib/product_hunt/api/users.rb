module ProductHunt
  module API
    module Users

      USERS_PATH = "/users"
      CURRENT_USER_PATH = "/me"

      def users(options = {})
        process(USERS_PATH, options) do |response|
          response["users"].map{ |user| User.new(user, self) }
        end
      end

      def user(id, options = {})
        process(USERS_PATH + "/#{id}", options) do |response|
          User.new(response["user"], self)
        end
      end

      def current_user(options = {})
        process(CURRENT_USER_PATH, options) do |response|
          User.new(response["user"], self)
        end
      end

    end
  end
end
