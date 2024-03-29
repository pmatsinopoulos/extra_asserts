Gem::Specification.new do |s|
  s.name = 'extra_asserts'
  s.version = '1.0.0'
  s.author = 'Panayotis Matsinopoulos'
  s.require_paths = ["lib"]
  s.rubyforge_project = 'extra_asserts'
  s.rubygems_version = '1.8.6'
  s.summary = %q{Extra ActiveSupport::TestCase assert methods for Rails 3.X projects}
  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["~> 3.0"])
      s.add_runtime_dependency(%q<validator_attachment>)
    else
      s.add_dependency(%q<activesupport>, ["~> 3.0"])
      s.add_dependency(%q<validator_attachment>)
    end
  else
    s.add_dependency(%q<activesupport>, ["~> 3.0"])
    s.add_dependency(%q<validator_attachment>)
  end
end
