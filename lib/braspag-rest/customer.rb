module BraspagRest
  class Customer < Hashie::IUTrash
    property :name, from: 'Name'
    property :identity, from: 'Identity'
  end
end
