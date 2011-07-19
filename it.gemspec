Gem::Specification.new do |s|
  s.name = %q{it}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Johannes Barre"]
  s.date = %q{2011-07-19}
  s.email = %q{igel@igels.net}
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files = [
    "MIT-LICENSE",
    "README.textile",
    "lib/it.rb",
    "lib/it/helper.rb",
    "spec/it/helper_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/igel/it}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{A helper for links and other html tags in your translations}
  s.test_files = [
    "spec/it/helper_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.add_development_dependency('actionpack', '~> 3.0.0')
  s.add_development_dependency('rspec', '~> 2.6.0')
end