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
    property :transaction_id, from: 'AcquirerTransactionId'
    property :authorization_code, from: 'AuthorizationCode'
    property :reason_code, from: 'ReasonCode'
    property :reason_message, from: 'ReasonMessage'

    coerce_key :credit_card, BraspagRest::CreditCard

    def authorized?
      status.to_i == 1
    end
  end
end
