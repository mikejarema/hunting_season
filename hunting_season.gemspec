Gem::Specification.new do |s|
  s.name          = "hunting_season"
  s.version       = "0.0.1"
  s.licenses      = ['MIT']
  s.summary       = %q{Ruby gem which interfaces with Product Hunt's official REST API.}
  s.description   = %q{This gem is a work-in-progress which allows for calls to both the posts#show and votes#index endpoints.}
  s.authors       = ["Mike Jarema"]
  s.date          = %q{2014-12-18}
  s.email         = %q{mike@jarema.com}
  s.files         = ["lib/hunting_season.rb", "lib/product_hunt/api.rb", "spec/product_hunt_spec.rb", "spec/spec_helper.rb"]
  s.homepage      = %q{http://rubygems.org/gems/hunting_season}
  s.require_paths = ["lib"]

  s.add_runtime_dependency "httparty", '~> 0'
  s.add_runtime_dependency "rake", '~> 10'

  s.add_development_dependency "rspec", '~> 2' # waiting on https://github.com/okitan/rspec-todo/issues/2 before bumping to 3
  s.add_development_dependency "rspec-todo", '~> 0'
end
