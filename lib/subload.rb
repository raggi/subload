# TODO convert to yardoc
module Subload
  # To add modes to subload, simply add them to this hash. Please use the
  # a namespace convention, starting with +:projectname_operationdescription+.
  MODES = {
    :autoload => lambda { |o,s,p,ops| o.__send__ :autoload, s, p },
    :require  => lambda { |o,s,p,ops| o.__send__ :require, p },
    :load     => lambda { |o,s,p,ops| o.__send__ :load, p }
  }

  @default_mode = :autoload
  class <<self
    # Subload defaults to autoload, which is appropriate and performant for
    # single threaded applications and libraries. Setting the default mode
    # will affect all future subloads that do not specify another mode
    # explicitly, proided +Subload.override_mode+ has not been set.
    attr_accessor :default_mode
    # Subload defaults to autoload, which is appropriate and performant for
    # single threaded applications and libraries. Sometimes users may want to
    # switch to eager loading or some other loading mechanism forcefully.
    # Override mode should not be set in normal library code, but should be
    # reserved for application code only. It may be acceptable for use in
    # appropriate locations in frameworks.
    attr_accessor :override_mode
  end

  # Sets the subload mode locally for the current class. This is how one would
  # use a custom loading mode
  def subload_with(mode = nil)
    @_subload_mode = mode unless mode.nil?
    MODES[Subload.override_mode || @_subload_mode || Subload.default_mode]
  end

  # Load the given constant name from the path corresponding to the
  # conventional mapping of the class name underscored. Example:
  #  class A
  #   subload :B # performs A.autoload(:B, 'a/b')
  #  end
  #
  # You can overload various operation styles in subload using the options
  # hash:
  # * :path - explicitly alter the path that will be loaded, this is passed on
  #   unmodified.
  # * :mode - explicitly override the loading mode. N.B. Subload.override_mode
  #   takes precidence over this.
  # * :expand_path - when set to true, the path will be expanded before being
  #   passed on to the loading mechanism.
  #
  # For custom loading mechanisms, further options are passed on, as such, you
  # may find other behaviors if subload is being used inside a framework.
  def subload(symbol, options = {})
    sub_path, mode = *options.values_at(:path, :mode)
    klass = self.instance_of?(Class) || self.instance_of?(Module)
    klass = klass ? self.__name__ : self.class.__name__
    path = File.join(sub_path || Subload.to_path("#{klass}::#{symbol}"))
    path = File.expand_path(path) if options[:expand_path]
    $stdout.puts [:subload, symbol, path, mode].inspect if $DEBUG
    subload_with(mode)[self, symbol, path, options]
  end

  LONG_UPPER_CONSTS = [/([A-Z]+)([A-Z][a-z]+)/, '\1_\2']
  TAIL_UPPER_CONSTS = [/([a-z])([A-Z])/, '\1_\2']
  DOUBLE_UNDERSCORE = '__'
  DOUBLE_COLON = '::'
  SLASH = '/'

  # Subloads snake_case method, this is very similar to that of facets, rails,
  # and merb, but potentially has minor differences.
  def self.to_path(s)
    # similar to facets/string/pathize, only supports TCPServer, etc.
    s = s.to_s.dup # We're modifying, lets be careful
    s.gsub!(*LONG_UPPER_CONSTS)
    s.gsub!(*TAIL_UPPER_CONSTS)
    s.gsub!(DOUBLE_UNDERSCORE, SLASH)
    s.gsub!(DOUBLE_COLON, SLASH)
    s.downcase!
    s
  end
end

class Object
  # Make sure we hit the top level, objects, classes, etc. We do not make this
  # private, because source loading may want to not be, for more complex
  # loading environments. External invocation is not recommended without clear
  # reasoning.
  include Subload
end

class Module
  # If anyone can think of a better way to do this, please, I'm all ears.
  # I'd like syntax for class_name?(object || klass) # => Symbol || String
  if defined?(__name__)
    warn("Subload clobber Class#__name__ from: #{method(:__name__).inspect}")
  else
    alias __name__ name
  end
end