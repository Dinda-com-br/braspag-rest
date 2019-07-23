module BraspagRest
  class DebitCard < Hashie::IUTrash
    property :number, from: 'CardNumber'
    property :holder, from: 'Holder'
    property :expiration_date, from: 'ExpirationDate'
    property :security_code, from: 'SecurityCode'
    property :brand, from: 'Brand'
  end
end
