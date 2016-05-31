module BraspagRest
  module FraudAnalyses
    class Leg < Hashie::IUTrash
      property :destination, from: 'Destination'
      property :origin, from: 'Origin'
    end
  end
end
