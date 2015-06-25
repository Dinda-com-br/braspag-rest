module BraspagRest
  class Sale < Hashie::IUTrash
    property :order_id, from: 'MerchantOrderId'
    property :customer, from: 'Customer', with: ->(values) { BraspagRest::Customer.new(values) }
    property :payment, from: 'Payment', with: ->(values) { BraspagRest::Payment.new(values) }
  end
end
