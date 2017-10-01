module BraspagRest
  class Address < Hashie::IUTrash
    property :street, from: 'Street'
    property :number, from: 'Number'
    property :complement, from: 'Complement'
    property :zip_code, from: 'ZipCode'
    property :city, from: 'City'
    property :state, from: 'State'
    property :country, from: 'Country'
    property :district, from: 'District'
  end
end
