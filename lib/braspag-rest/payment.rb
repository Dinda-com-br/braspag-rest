module BraspagRest
  class Payment < Hashie::IUTrash
    include Hashie::Extensions::Coercion

    STATUS_AUTHORIZED = 1
    STATUS_CONFIRMED = 2
    STATUS_VOIDED = 10

    property :id, from: 'PaymentId'
    property :type, from: 'Type'
    property :amount, from: 'Amount'
    property :status, from: 'Status'
    property :provider, from: 'Provider'
    property :installments, from: 'Installments'
    property :credit_card, from: 'CreditCard', with: ->(values) { BraspagRest::CreditCard.new(values) }
    property :transaction_id, from: 'AcquirerTransactionId'
    property :authorization_code, from: 'AuthorizationCode'
    property :proof_of_sale, from: 'ProofOfSale'
    property :reason_code, from: 'ReasonCode'
    property :reason_message, from: 'ReasonMessage'
    property :voided_amount, from: 'VoidedAmount'

    property :digitable_line, from: 'DigitableLine'
    property :barcode_number, from: 'BarCodeNumber'
    property :printable_page_url, from: 'Url'

    coerce_key :credit_card, BraspagRest::CreditCard

    def authorized?
      status.to_i.eql?(STATUS_AUTHORIZED)
    end

    def captured?
      status.to_i.eql?(STATUS_CONFIRMED)
    end

    def cancelled?
      status.to_i.eql?(STATUS_VOIDED)
    end
  end
end
