require 'spec_helper'

describe BraspagRest::Customer do
  let(:braspag_response) {
    {
      'Name' => 'Comprador Teste',
      'Identity' => '790.010.515-88',
      'IdentityType' => 'CPF',
      'Address' => {
        'Street' => 'Alameda Xingu',
        'Number' => '512',
        'Complement' => '27 andar',
        'ZipCode' => '12345987',
        'City' => 'São Paulo',
        'State' => 'SP',
        'Country' => 'BRA',
        'District' => 'Alphaville'
      }
    }
  }

  describe '.new' do
    subject(:customer) { BraspagRest::Customer.new(braspag_response) }

    it 'initializes a customer using braspag response format' do
      expect(customer.name).to eq('Comprador Teste')
      expect(customer.identity).to eq('790.010.515-88')
      expect(customer.identity_type).to eq('CPF')
      expect(customer.address).to be_an_instance_of(BraspagRest::Address)
    end
  end
end
