module BraspagRest
  module FraudAnalyses
    class MerchantDefinedFields < Hashie::IUTrash
      property :id, from: 'Id'
      property :value, from: 'Value'
    end
  end
end
