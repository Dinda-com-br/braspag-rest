module BraspagRest
  module FraudAnalyses
    class Travel < Hashie::IUTrash
      include Hashie::Extensions::Coercion

      property :departure_time, from: 'DepartureTime'
      property :journey_type, from: 'JourneyType'
      property :route, from: 'Route'
      property :legs, from: 'Legs'

      coerce_key :legs, Array[BraspagRest::FraudAnalyses::Leg]
    end
  end
end
