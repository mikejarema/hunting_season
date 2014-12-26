# TODO: factor out a base class btw User and Post

module ProductHunt
  module API
    include ProductHunt::API::Posts
    include ProductHunt::API::Users
  end
end
