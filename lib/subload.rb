module Subload
  MODES = {
    :autoload => lambda { |o,s,p| o.__send__ :autoload, s, p },
    :require  => lambda { |o,s,p| o.__send__ :require, p },
    :load     => lambda { |o,s,p| o.__send__ :load, p }
  }

  @default_mode = :autoload
  class <<self; attr_accessor :default_mode, :override_mode; end

  def subload_with(mode = nil)
    @_subload_mode = mode unless mode.nil?
    MODES[Subload.override_mode || @_subload_mode || Subload.default_mode]
  end

  def subload(symbol, sub_path = nil, mode = nil)
    klass = self.instance_of?(Class) || self.instance_of?(Module)
    klass = klass ? self.name : self.class.name
    path = File.join(sub_path || Subload.to_path("#{klass}::#{symbol}"))
    $stdout.puts [:subload, symbol, path, mode].inspect if $DEBUG
    subload_with(mode)[self, symbol, path]
  end

  LONG_UPPER_CONSTS = [/([A-Z]+)([A-Z])([a-z]+)/, '\1_\2\3']
  TAIL_UPPER_CONSTS = [/([a-z])([A-Z])/, '\1_\2']
  DOUBLE_UNDERSCORE = '__'
  DOUBLE_COLON = '::'
  SLASH = '/'

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
  include Subload
end