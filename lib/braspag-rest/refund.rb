module BraspagRest
  class Refund < Hashie::IUTrash
    include Hashie::Extensions::Coercion

    STATUS_REFUNDED = 11

    property :status, from: 'Status'
    property :amount, from: 'Amount'
    property :received_date, from: 'ReceivedDate'

    def success?
      status.to_i.eql?(STATUS_REFUNDED)
    end
  end
end
