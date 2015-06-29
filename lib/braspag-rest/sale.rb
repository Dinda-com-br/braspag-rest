module BraspagRest
  class Sale < Hashie::IUTrash
    include Hashie::Extensions::Coercion

    attr_reader :errors

    property :request_id, from: 'RequestId'
    property :order_id, from: 'MerchantOrderId'
    property :customer, from: 'Customer', with: ->(values) { BraspagRest::Customer.new(values) }
    property :payment, from: 'Payment', with: ->(values) { BraspagRest::Payment.new(values) }

    coerce_key :customer, BraspagRest::Customer
    coerce_key :payment, BraspagRest::Payment

    def save
      response = BraspagRest::Request.authorize(request_id, inverse_attributes)

      if response.success?
        initialize_attributes(response.parsed_body)
      else
        initialize_errors(response.parsed_body) and return false
      end

      true
    end

    private

    def initialize_errors(errors)
      @errors = errors.map{ |error| { code: error['Code'], message: error['Message'] } }
    end
  end
end
