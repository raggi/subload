# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{subload}
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Tucker"]
  s.date = %q{2009-09-10}
  s.description = %q{An autoload/require/custom loader wrapper}
  s.email = %q{raggi@rubyforge.org}
  s.extra_rdoc_files = ["README"]
  s.files = ["README", "Rakefile", "examples/a.rb", "examples/a/foo.rb", "examples/a/foo/bar.rb", "examples/a/foo/baz.rb", "examples/rails/loader.rb", "lib/subload.rb", "test/test_subload.rb", "test/test_subload/a.rb", "test/test_subload/b.rb", "test/test_subload/c.rb", "test/test_subload/d.rb", "test/test_subload/e.rb", "test/test_subload/f.rb", "test/test_subload/f/a.rb"]
  s.homepage = %q{http://libraggi.rubyforge.org/subload}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Subload", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{libraggi}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{An autoload/require/custom loader wrapper}
  s.test_files = ["test/test_subload.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rdoc>, [">= 2.4.3"])
      s.add_development_dependency(%q<rake>, [">= 0.8.7"])
    else
      s.add_dependency(%q<rdoc>, [">= 2.4.3"])
      s.add_dependency(%q<rake>, [">= 0.8.7"])
    end
  else
    s.add_dependency(%q<rdoc>, [">= 2.4.3"])
    s.add_dependency(%q<rake>, [">= 0.8.7"])
  end
end
