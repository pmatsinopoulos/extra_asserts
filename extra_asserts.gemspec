Gem::Specification.new do |s|
  s.name = 'extra_asserts'
  s.version = '1.0.0'
  s.author = 'Panayotis Matsinopoulos'
  s.require_paths = ["lib"]
  s.rubyforge_project = 'extra_asserts'
  s.rubygems_version = '1.8.6'
  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["~> 3.0.0"])
    else
      s.add_dependency(%q<activesupport>, ["~> 3.0.0"])
    end
  else
    s.add_dependency(%q<activesupport>, ["~> 3.0.0"])
  end
end