module BraspagRest
  class CreditCard < Hashie::IUTrash
    property :number, from: 'CardNumber'
    property :holder, from: 'Holder'
    property :expiration_date, from: 'ExpirationDate'
    property :security_code, from: 'SecurityCode'
    property :brand, from: 'Brand'
    property :saved, from: 'SaveCard'
    property :token, from: 'CardToken'
  end
end
