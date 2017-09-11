module BraspagRest
  def self.config
    @config ||= BraspagRest::Configuration.new
    yield @config if block_given?
    @config
  end
end

require 'hashie'
require 'rest-client'
require 'braspag-rest/hashie'
require 'braspag-rest/version'
require 'braspag-rest/configuration'
require 'braspag-rest/response'
require 'braspag-rest/request'
require 'braspag-rest/customer'
require 'braspag-rest/credit_card'
require 'braspag-rest/fraud_analyses'
require 'braspag-rest/fraud_analysis'
require 'braspag-rest/refund'
require 'braspag-rest/payment'
require 'braspag-rest/sale'
