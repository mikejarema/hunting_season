module ProductHunt
  module API
    include ProductHunt::API::CurrentUser
    include ProductHunt::API::Posts
    include ProductHunt::API::Users
  end
end
