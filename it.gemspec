Gem::Specification.new do |s|
  s.name = %q{it}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Johannes Barre"]
  s.date = Time.now.strftime("%Y-%m-%d")
  s.email = %q{igel@igels.net}
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files = [
    "MIT-LICENSE",
    "README.textile",
    "Rakefile",
    "Gemfile",
    "lib/it.rb",
    "lib/it/helper.rb",
    "lib/it/tag.rb",
    "lib/it/link.rb",
    "lib/it/plain.rb",
    "spec/it/helper_spec.rb",
    "spec/it/link_spec.rb",
    "spec/it/tag_spec.rb",
    "spec/it/plain_spec.rb",
    "spec/it_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{https://github.com/igel/it}
  s.require_paths = ["lib"]
  s.required_rubygems_version = ">= 1.3.6"
  s.summary = %q{A helper for links and other html tags in your translations}
  s.test_files = [
    "spec/it/helper_spec.rb",
    "spec/it/link_spec.rb",
    "spec/it/tag_spec.rb",
    "spec/it/plain_spec.rb",
    "spec/it_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.add_dependency('actionpack', '>= 3.0.0')
  s.add_development_dependency('rspec', '~> 2.6.0')
end
