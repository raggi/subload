$:.unshift File.expand_path(File.dirname(__FILE__) + '/../../lib')
require 'subload'

module Rails
  def self.production?
    # flip me, baby
    false
  end

  module Loader
    Subloader = lambda do |calling_object, const_name, path, options|
      # Example is allowing override exclusively in a particular mode, but we
      # could also be simply registering what's being loaded instead, and
      # doing some other magic.
      if Rails.production? && options[:eager_load]
        require path
      else
        calling_object.__send__ :autoload, const_name, path
      end
    end

    Subload::MODES[:rails_subloader] = Subloader
    subload_with(:rails_subloader)
    subload :SomethingWeDontCareAbout
    subload :SomethingEssentialForThreadedBoot, :eager_load => true
  end
end