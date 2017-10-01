module BraspagRest
  class Customer < Hashie::IUTrash
    property :name, from: 'Name'
    property :identity, from: 'Identity'
    property :identity_type, from: 'IdentityType'
  end
end
