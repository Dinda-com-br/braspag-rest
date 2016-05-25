module BraspagRest
  module FraudAnalyses
    class Item < Hashie::IUTrash
      include Hashie::Extensions::Coercion

      property :gift_category, from: 'GiftCategory'
      property :host_hedge, from: 'HostHedge'
      property :non_sensical_hedge, from: 'NonSensicalHedge'
      property :obscenities_hedge, from: 'ObscenitiesHedge'
      property :phone_hedge, from: 'PhoneHedge'
      property :name, from: 'Name'
      property :quantity, from: 'Quantity'
      property :sku, from: 'Sku'
      property :unit_price, from: 'UnitPrice'
      property :risk, from: 'Risk'
      property :time_hedge, from: 'TimeHedge'
      property :type, from: 'Type'
      property :velocity_hedge, from: 'VelocityHedge'
      property :passenger, from: 'Passenger'

      coerce_key :passenger, BraspagRest::FraudAnalyses::Passenger
    end
  end
end
