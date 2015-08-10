module ProductHunt
  module API
    module Users

      PATH = "/users"

      def users(options = {})
        process(PATH, options) do |response|
          response["users"].map{ |user| User.new(user, self) }
        end
      end

      def user(id, options = {})
        process(PATH + "/#{id}", options) do |response|
          User.new(response["user"], self)
        end
      end

    end
  end
end
