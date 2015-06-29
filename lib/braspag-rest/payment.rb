module BraspagRest
  class Payment < Hashie::IUTrash
    include Hashie::Extensions::Coercion

    property :id, from: 'PaymentId'
    property :type, from: 'Type'
    property :amount, from: 'Amount'
    property :status, from: 'Status'
    property :provider, from: 'Provider'
    property :installments, from: 'Installments'
    property :credit_card, from: 'CreditCard', with: ->(values) { BraspagRest::CreditCard.new(values) }

    coerce_key :credit_card, BraspagRest::CreditCard
  end
end
