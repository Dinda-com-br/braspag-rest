module BraspagRest
  def self.config
    yield BraspagRest::Configuration.instance if block_given?

    BraspagRest::Configuration.instance
  end
end

require 'hashie'
require 'braspag-rest/hashie'
require 'braspag-rest/version'
require 'braspag-rest/configuration'
require 'braspag-rest/customer'
require 'braspag-rest/credit_card'
require 'braspag-rest/payment'
require 'braspag-rest/sale'
