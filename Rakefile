#!/usr/bin/env rake
require 'rake/clean'

task :default => :spec

def spec(file = Dir['*.gemspec'].first)
  @spec ||=
  begin
    require 'rubygems/specification'
    Thread.abort_on_exception = true
    data = File.read(file)
    spec = nil
    Thread.new { spec = eval("$SAFE = 3\n#{data}") }.join
    spec.instance_variable_set(:@filename, file)
    def spec.filename; @filename; end
    spec
  end
end

def manifest; @manifest ||= `git ls-files`.split("\n").reject{|s|s=~/\.gemspec$|\.gitignore$/}; end

@gem_package_task_type = begin
  require 'rubygems/package_task'
  Gem::PackageTask
rescue LoadError
  require 'rake/gempackagetask'
  Rake::GemPackageTask
end
def gem_task; @gem_task ||= @gem_package_task_type.new(spec); end
gem_task.define
Rake::Task[:clobber].enhance [:clobber_package]

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.test_files = spec.test_files
  t.ruby_opts = ['-rubygems'] if defined? Gem
  t.warning = true
end unless spec.test_files.empty?

rdoc_task_type = begin
  require 'rdoc/task'
  RDoc::Task
rescue LoadError
  require 'rake/rdoctask'
  Rake::RDocTask
end
df = begin; require 'rdoc/generator/darkfish'; true; rescue LoadError; end
rdtask = rdoc_task_type.new do |rd|
  rd.title = spec.name
  rd.main = spec.extra_rdoc_files.first
  lib_rexp = spec.require_paths.map { |p| Regexp.escape p }.join('|')
  rd.rdoc_files.include(*manifest.grep(/^(?:#{lib_rexp})/))
  rd.rdoc_files.include(*spec.extra_rdoc_files)
  rd.template = 'darkfish' if df
end

Rake::Task[:clobber].enhance [:clobber_rdoc]

require 'yaml'
require 'rake/contrib/sshpublisher'
desc "Publish rdoc to rubyforge"
task :publish => rdtask.name do
  rf_cfg = File.expand_path '~/.rubyforge/user-config.yml'
  host = "#{YAML.load_file(rf_cfg)['username']}@rubyforge.org"
  remote_dir = "/var/www/gforge-projects/#{spec.rubyforge_project}/#{spec.name}/"
  Rake::SshDirPublisher.new(host, remote_dir, rdtask.rdoc_dir).upload
end

desc 'Generate and open documentation'
task :docs => :rdoc do
  path = rdtask.send :rdoc_target
  case RUBY_PLATFORM
  when /darwin/       ; sh "open #{path}"
  when /mswin|mingw/  ; sh "start #{path}"
  else 
    sh "firefox #{path}"
  end
end

desc "Regenerate gemspec"
task :gemspec => spec.filename

task spec.filename do
  spec.files = manifest
  spec.test_files = FileList['{test,spec}/**/{test,spec}_*.rb']
  open(spec.filename, 'w') { |w| w.write spec.to_ruby }
end

desc "Bump version from #{spec.version} to #{spec.version.to_s.succ}"
task :bump do
  spec.version = spec.version.to_s.succ
end

desc "Tag version #{spec.version}"
task :tag do
  tagged = Dir.new('.git/refs/tags').entries.include? spec.version.to_s
  if tagged
    warn "Tag #{spec.version} already exists"
  else
    # TODO release message in tag message
    sh "git tag #{spec.version}"
  end
end

desc "Release #{gem_task.gem_file} to rubyforge"
task :release => [:tag, :gem, :publish] do |t|
  sh "rubyforge add_release #{spec.rubyforge_project} #{spec.name} #{spec.version} #{gem_task.package_dir}/#{gem_task.gem_file}"
end