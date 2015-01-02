# hunting_season [![Build Status](https://secure.travis-ci.org/mikejarema/hunting_season.png)](http://travis-ci.org/mikejarema/hunting_season)

Ruby gem for interacting with the official [Product Hunt API](https://api.producthunt.com/v1/docs).


## Authentication

Currently only supports a single token, passed to `ProductHunt::Client.new(token)`. This mainly supports the use case of using the _Developer Token_ which can be created in the API Dashboard.


## Supported Endpoints

### [posts#show - Get details of a post](https://api.producthunt.com/v1/docs/posts/posts_show_get_details_of_a_post)

Look up a post using a required numeric ID.

Post attributes are listed in the API docs and accessed like `post["name"]`, `post["id"]`, etc.

Example:
```
client = ProductHunt::Client.new('mytoken')
post = client.post(3372)
post["name"]
# => "namevine"
post["id"]
# => 3372
```


### [votes#index - See all votes for a post](https://api.producthunt.com/v1/docs/postvotes/votes_index_see_all_votes_for_a_post)

Look up a post's votes, with optional ordering and pagination.

Post attributes are listed in the API docs and accessed like `vote["user"]`, `vote["id"]`, etc.

Example, look up a post's votes and paginate through them in ascending order:
```
client = ProductHunt::Client.new('mytoken')
post = client.post(3372)

votes = post.votes(per_page: 2, order: 'asc')
votes[0]["id"]
# => 46164
"#{votes[0]["user"]["name"]} #{votes[0]["user"]["headline"]}"
# => "Jack Smith  Co-Founded Vungle - Advisor to Coin"

votes_page_2 = post.votes(per_page: 2, order: 'asc', newer: votes.last["id"])
votes_page_2[0]["id"]
# => 46242
"#{votes_page_2[0]["user"]["name"]} #{votes_page_2[0]["user"]["headline"]}"
# => "Helen Crozier Keyboard Karma"
```


### [users#show - Get details of a user](https://api.producthunt.com/v1/docs/users/users_show_get_details_of_a_user)

Look up a user by username or id.

User attributes are listed in the API docs and accessed like `user["name"]`, `user["headline"]`, etc.

Example:
```
client = ProductHunt::Client.new('mytoken')
user = client.user('rrhoover')
user["name"]
# => "Ryan Hoover"
user["headline"]
# => "Product Hunt"
```


### [comments#index - Fetch all comments of a post](https://api.producthunt.com/v1/docs/comments/comments_index_fetch_all_comments_of_a_post)

Look up a post's comments, with optional ordering and pagination.

Example, look up a post's comments and paginate through them in ascending order:
```
client = ProductHunt::Client.new('mytoken')
post = client.post(3372)

comments = post.comments(per_page: 2, order: 'asc')
comments[0]["id"]
# => 11378
"#{comments[0]["user"]["name"]}: #{comments[0]["body"]}"
# => "Andreas Klinger: fair point but not using thesaurus nor having the ..."

comments_page_2 = post.comments(per_page: 2, order: 'asc', newer: comments.last["id"])
comments_page_2[0]["id"]
# => 11558
"#{comments_page_2[0]["user"]["name"]}: #{comments_page_2[0]["body"]}"
# => "Mike Jarema: Namevine developer here -- feel free to ask any Qs about ..."
```


## Tests

There are two ways to run tests:

1. `env TOKEN=mytoken bundle exec rake` which stubs out all of the calls to Product Hunt's API to local files.

2. `env TOKEN=mytoken SKIP_CALL_STUBS=true bundle exec rake` which runs tests against live data from the Product Hunt API.


## Contributing

Easy -- fork the project, add your desired functionality, include relevant tests, ensure all others pass and submit a PR.


## Miscellany

Legal: see LICENSE

The name is inspired by a rapper buddy of mine: [Katchphraze - Huntin' Season](http://on.rdio.com/1zEb5cA) :headphones:

Copyright (c) 2014 Mike Jarema
