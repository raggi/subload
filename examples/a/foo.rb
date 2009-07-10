module A
  class Foo
    subload_with(:require)
    subload :Bar
    subload :Baz
  end
end