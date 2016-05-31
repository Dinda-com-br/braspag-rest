module BraspagRest
  module FraudAnalyses
    class Shipping < Hashie::IUTrash
      property :addressee, from: 'Addressee'
      property :method, from: 'Method'
      property :phone, from: 'Phone'
    end
  end
end
