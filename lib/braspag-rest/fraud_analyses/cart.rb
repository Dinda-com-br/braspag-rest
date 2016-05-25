module BraspagRest
  module FraudAnalyses
    class Cart < Hashie::IUTrash
      include Hashie::Extensions::Coercion

      property :is_gift, from: 'IsGift'
      property :returns_accepted, from: 'ReturnsAccepted'
      property :items, from: 'Items'

      coerce_key :items, Array[Item]
    end
  end
end
