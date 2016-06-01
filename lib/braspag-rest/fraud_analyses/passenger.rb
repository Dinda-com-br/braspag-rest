module BraspagRest
  module FraudAnalyses
    class Passenger < Hashie::IUTrash
      property :email, from: 'Email'
      property :identity, from: 'Identity'
      property :name, from: 'Name'
      property :rating, from: 'Rating'
      property :phone, from: 'Phone'
      property :status, from: 'Status'
    end
  end
end
