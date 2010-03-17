require "test/unit"
require "subload"

class TestSubload < Test::Unit::TestCase
  # pretend we're in a libdir!
  $:.unshift File.expand_path(File.dirname(__FILE__))

  def teardown
    Subload.override_mode = nil
    Subload.default_mode = :autoload
    subload_with(false)
  end

  subload :A

  def test_subload_defaults
    assert !defined?(Al) # Not loaded already (defaults to autoload)
    assert_equal(true, A) # Autoloaded
    assert defined?(Al)
  end

  def test_subload_require
    subload :B, :mode => :require
    assert defined?(B)
  end

  def test_subload_load
    subload :C, :path => "test_subload/c.rb", :mode => :load
    assert defined?(C)
  end

  def test_subload_with
    subload_with(:require)
    subload :D
    subload_with(false)

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

  def test_override_mode
    assert !defined?(F)
    assert !defined?(F::Al)
    assert !defined?(F::A)
    Subload.override_mode = :require
    subload_with(:autoload)
    subload :F
    assert defined?(F)
    assert defined?(F::Al)
    assert defined?(F::A)
  end

  def test___name__
    assert_equal("Class", Class.__name__)
    assert_equal("Module", Module.__name__)
  end

  def test_to_path
    assert_equal 'c2c2_api', Subload.to_path('C2C2Api')
    assert_equal '123_api', Subload.to_path('123Api')
    assert_equal 'http_error', Subload.to_path('HTTPError')
    assert_equal 'no_method_error', Subload.to_path('NoMethodError')
  end
end
