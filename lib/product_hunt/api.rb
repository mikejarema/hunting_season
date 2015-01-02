module ProductHunt
  module API
    include ProductHunt::API::Posts
    include ProductHunt::API::Users
  end
end
