module BraspagRest
  class Payment < Hashie::IUTrash
    include Hashie::Extensions::Coercion

    STATUS_AUTHORIZED = 1
    STATUS_CONFIRMED = 2
    STATUS_VOIDED = 10

    property :id, from: 'PaymentId'
    property :type, from: 'Type'
    property :amount, from: 'Amount'
    property :captured_amount, from: 'CapturedAmount'
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
    property :expiration_date, from: 'ExpirationDate'
    property :instructions, from: 'Instructions'
    property :printable_page_url, from: 'Url'

    property :currency, from: 'Currency'
    property :country, from: 'Country'
    property :service_tax_amount, from: 'ServiceTaxAmount'
    property :interest, from: 'Interest'
    property :capture, from: 'Capture'
    property :authenticate, from: 'Authenticate'
    property :soft_descriptor, from: 'SoftDescriptor'
    property :fraud_analysis, from: 'FraudAnalysis'

    # Response fields
    property :received_date, from: 'ReceivedDate'
    property :provider_return_code, from: 'ProviderReturnCode'
    property :provider_return_message, from: 'ProviderReturnMessage'
    property :links, from: 'Links'

    coerce_key :fraud_analysis, BraspagRest::FraudAnalysis
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
