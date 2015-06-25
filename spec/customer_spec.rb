require 'spec_helper'

describe BraspagRest::Customer do
  let(:braspag_response) {
    {
      'Name' => 'Comprador Teste'
    }
  }

  describe '.new' do
    subject(:customer) { BraspagRest::Customer.new(braspag_response) }

    it 'initializes a customer using braspag response format' do
      expect(customer.name).to eq('Comprador Teste')
    end
  end
end
