# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'podflow/version'

Gem::Specification.new do |gem|
  gem.name          = "podflow"
  gem.version       = Podflow::VERSION
  gem.authors       = ["Andy White"]
  gem.email         = ["andy@summitsolutions.co.uk"]
  gem.description   = %q{Podcast packaging and deployment tools}
  gem.summary       = %q{Podflow is a suite of tools to streamline the process of audio podcast tagging, deployment and delivery, and RSS generation and maintenance.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency "gli"
  gem.add_development_dependency "rspec"
end
