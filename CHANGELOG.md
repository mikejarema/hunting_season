# 0.0.4

- updated README to include further notes on authentication, code examples, contribution notes
- instantiating associated objects via ProductHunt::Entity#user and #post
- removing depracted .should syntax in specs in favour of expect().to

# 0.0.3

- stubbing API calls using WebMock
- all API calls to pass through to Product Hunt's API with ENV['SKIP_CALL_STUBS']=true
- factoring out Entity class from User, Post, Vote classes
