# hunting_season [![Build Status](https://secure.travis-ci.org/mikejarema/hunting_season.png)](http://travis-ci.org/mikejarema/hunting_season)

Ruby gem for interacting with the official [Product Hunt API](https://api.producthunt.com/v1/docs).


## Authentication

Currently only supports a single token, passed to `ProductHunt::API.new(token)`. This mainly supports the use case of using the _Developer Token_ which can be created in the API Dashboard.


## Supported Endpoints

* [posts#show - Get details of a post](https://api.producthunt.com/v1/docs/posts/posts_show_get_details_of_a_post)
* [votes#index - See all votes for a post](https://api.producthunt.com/v1/docs/postvotes/votes_index_see_all_votes_for_a_post)


## Examples

For now, see `product_hunt_spec.rb` for examples covering each of the supported endpoints.


## Miscellany

Legal: see LICENSE

Quick shout out to [Katchphraze](http://on.rdio.com/1zEb5cA) for unintentionally naming this gem 7 years later :headphones:

Copyright (c) 2014 Mike Jarema
