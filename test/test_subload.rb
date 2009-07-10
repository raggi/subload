begin
  require 'minitest/unit'
rescue LoadError
  warn("Please install minitest, falling back to test/unit")
  require "test/unit"
end

$:.unshift(File.expand_path(File.dirname(__FILE__) + '/../lib'))
require "subload"

class TestSubload < Test::Unit::TestCase
  # pretend we're in a libdir!
  $:.unshift File.expand_path(File.dirname(__FILE__))

  subload :A

  def test_subload_defaults
    assert !defined?(Al) # Not loaded already (defaults to autoload)
    assert_equal(true, A) # Autoloaded
    assert defined?(Al)
  end

  subload :B, nil, :require

  def test_subload_require
    assert defined?(B)
  end

  subload :C, "test_subload/c.rb", :load

  def test_subload_load
    assert defined?(C)
  end

  subload_with(:require)
  subload :D
  subload_with(false)

  def test_subload_with
    assert_equal subload_with(false), subload_with
    assert_equal subload_with(:autoload), subload_with

    assert defined?(Dl) # Was required before we hit D
    assert defined?(D)
  end

  def test_default_mode
    Subload.default_mode = :require
    assert_equal subload_with(:require), subload_with(nil)
  ensure
    Subload.default_mode = :autoload
    subload_with(false)
  end

  # TODO  tests for to_path
end