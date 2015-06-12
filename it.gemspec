lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'it/version'

Gem::Specification.new do |spec|
  spec.name          = "it"
  spec.version       = It::VERSION
  spec.authors       = ["Johannes Barre"]
  spec.email         = ["igel@igels.net"]

  spec.summary       = %q{A helper for links and other html tags in your translations}
  spec.homepage      = "https://github.com/igel/it"
  spec.license       = "MIT"

  spec.files         = %w(MIT-LICENSE README.md Rakefile Gemfile CHANGELOG.md it.gemspec) + Dir['lib/**/*.rb']
  spec.require_paths = ["lib"]

  spec.add_dependency 'actionpack', '>= 3.0.0'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'nokogiri'
end
