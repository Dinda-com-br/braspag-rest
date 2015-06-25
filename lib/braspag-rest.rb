module BraspagRest
  def self.config
    yield BraspagRest::Configuration.instance if block_given?

    BraspagRest::Configuration.instance
  end
end

require "braspag-rest/version"
require "braspag-rest/configuration"
