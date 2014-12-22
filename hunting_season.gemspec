Gem::Specification.new do |s|
  s.name          = "hunting_season"
  s.version       = File.open(File.dirname(__FILE__) + '/VERSION').read.strip
  s.licenses      = ['MIT']
  s.summary       = %q{Ruby gem which interfaces with Product Hunt's official REST API.}
  s.description   = %q{This gem is a work-in-progress which allows for calls to some of the offical API's endpoints (see README).}
  s.authors       = ["Mike Jarema"]
  s.date          = %q{2014-12-18}
  s.email         = %q{mike@jarema.com}
  s.files         = Dir.glob("{lib}/**/*") + %w(LICENSE README.md VERSION)
  s.homepage      = %q{http://rubygems.org/gems/hunting_season}
  s.require_paths = ["lib"]

  s.add_runtime_dependency "httparty", '~> 0'
  s.add_runtime_dependency "rake", '~> 10'

  s.add_development_dependency "rspec", '~> 2' # waiting on https://github.com/okitan/rspec-todo/issues/2 before bumping to 3
  s.add_development_dependency "rspec-todo", '~> 0'
end
