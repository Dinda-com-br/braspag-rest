lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'braspag-rest/version'

Gem::Specification.new do |spec|
  spec.name          = "braspag-rest"
  spec.version       = BraspagRest::VERSION
  spec.authors       = ["Dinda Dev Team"]
  spec.email         = ["dev@dinda.com.br"]

  spec.summary       = %q{Gem to use Braspag gateway in his REST version}
  spec.description   = %q{Gem to use Braspag gateway in his REST version}
  spec.homepage      = "https://github.com/Dinda-com-br/braspag-rest"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", "~> 2.0"
  spec.add_dependency "hashie", "~> 3.4"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "pry-byebug"
end
