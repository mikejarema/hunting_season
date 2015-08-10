module ProductHunt
  module API
    module Users

      PATH = "/users"

      def users(options = {})
        fetch(PATH, options)["users"].map{ |user| User.new(user, self) }
      end

      def user(id, options = {})
        process(PATH + "/#{id}", options) do |response|
          User.new(response["user"], self)
        end
      end

    end
  end
end
