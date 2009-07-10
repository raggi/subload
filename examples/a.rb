$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'subload'

module A
  # Normal subload, by file, looks in __DIR__/a/foo
  subload :Foo
  p Foo
  p Foo::Bar
end

p A::Foo::Baz