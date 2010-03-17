#!/usr/bin/env rake

require 'hoe'
Hoe.plugin :doofus, :git, :gemcutter

hoe = Hoe.spec 'subload' do
  developer "James Tucker", "raggi@rubyforge.org"
  extra_dev_deps << %w(hoe-doofus >=1.0.0)
  extra_dev_deps << %w(hoe-git >=1.3.0)
  extra_dev_deps << %w(hoe-gemcutter >=1.0.0)
  self.extra_rdoc_files = FileList["**/*.rdoc"]
  self.history_file     = "CHANGELOG.rdoc"
  self.readme_file      = "README.rdoc"
  self.rubyforge_name   = 'libraggi'
end

# TODO  make a plugin to deal with this
gem_spec_file = hoe.spec.name + '.gemspec'
version_file = %Q{lib/#{hoe.spec.name}.rb}

desc "Generate #{gem_spec_file}"
file gem_spec_file => hoe.spec.files - [gem_spec_file] do
  open(gem_spec_file, 'w') { |f| f.write hoe.spec.to_ruby }
end

task :package => gem_spec_file
task :check_manifest => gem_spec_file
