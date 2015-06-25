module BraspagRest
  class Payment < Hashie::IUTrash
    property :type, from: 'Type'
    property :amount, from: 'Amount'
    property :provider, from: 'Provider'
    property :installments, from: 'Installments'
    property :credit_card, from: 'CreditCard', with: ->(values) { BraspagRest::CreditCard.new(values) }
  end
end
