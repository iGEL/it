Gem::Specification.new do |s|
  s.name = %q{it}
  s.version = "0.2.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Johannes Barre"]
  s.date = Time.now.strftime("%Y-%m-%d")
  s.email = %q{igel@igels.net}
  s.extra_rdoc_files = %w(README.textile)
  s.files = %w(MIT-LICENSE README.textile Rakefile Gemfile) + Dir['**/*.rb']
  s.homepage = %q{https://github.com/igel/it}
  s.require_paths = ["lib"]
  s.required_rubygems_version = ">= 1.3.6"
  s.required_ruby_version = '>= 1.9.2'
  s.summary = %q{A helper for links and other html tags in your translations}
  s.test_files = Dir['spec/**/*_spec.rb'] << 'spec/spec_helper.rb'
  s.add_dependency('actionpack', '>= 3.0.0')
  s.add_development_dependency('rspec', '~> 2.11')
  s.add_development_dependency('rake', '>= 10.0')
end
