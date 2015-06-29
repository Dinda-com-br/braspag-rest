module BraspagRest
  class Customer < Hashie::IUTrash
    property :name, from: 'Name'
  end
end
