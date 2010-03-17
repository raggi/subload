# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{subload}
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Tucker"]
  s.date = %q{2010-03-17}
  s.description = %q{A handy dandy autoload / require / load helper for your rubies. Similar to
using[1], but with a few differences of opinion, and a bit shorter.

Basically, expand path is fine, up until a point. Sometimes there's no point
(i.e. when the load path already contains most of the path you're trying to
open). When you're writing libs that users might require sub parts with
'libname/sub_part', then expand_path combined with say, rubygems, can lead to
double requires. Lets not do that. :-)

[1] http://github.com/smtlaissezfaire/using/}
  s.email = ["raggi@rubyforge.org"]
  s.extra_rdoc_files = ["Manifest.txt", "CHANGELOG.rdoc", "README.rdoc"]
  s.files = ["CHANGELOG.rdoc", "Manifest.txt", "README.rdoc", "Rakefile", "examples/a.rb", "examples/a/foo.rb", "examples/a/foo/bar.rb", "examples/a/foo/baz.rb", "examples/rails/loader.rb", "lib/subload.rb", "subload.gemspec", "test/test_subload.rb", "test/test_subload/a.rb", "test/test_subload/b.rb", "test/test_subload/c.rb", "test/test_subload/d.rb", "test/test_subload/e.rb", "test/test_subload/f.rb", "test/test_subload/f/a.rb"]
  s.homepage = %q{gem: http://gemcutter.org/gems/subload}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{libraggi}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A handy dandy autoload / require / load helper for your rubies}
  s.test_files = ["test/test_subload.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe-doofus>, [">= 1.0.0"])
      s.add_development_dependency(%q<hoe-git>, [">= 1.3.0"])
      s.add_development_dependency(%q<hoe-gemcutter>, [">= 1.0.0"])
      s.add_development_dependency(%q<hoe>, [">= 2.3.3"])
    else
      s.add_dependency(%q<hoe-doofus>, [">= 1.0.0"])
      s.add_dependency(%q<hoe-git>, [">= 1.3.0"])
      s.add_dependency(%q<hoe-gemcutter>, [">= 1.0.0"])
      s.add_dependency(%q<hoe>, [">= 2.3.3"])
    end
  else
    s.add_dependency(%q<hoe-doofus>, [">= 1.0.0"])
    s.add_dependency(%q<hoe-git>, [">= 1.3.0"])
    s.add_dependency(%q<hoe-gemcutter>, [">= 1.0.0"])
    s.add_dependency(%q<hoe>, [">= 2.3.3"])
  end
end
