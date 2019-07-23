require 'spec_helper'

describe BraspagRest::DebitCard do
  let(:braspag_response) {
    {
       'ExpirationDate' => '12/2021',
       'Brand' => 'Visa',
       'CardNumber' => '000000******0001',
       'Holder' => 'Teste Holder',
       'SecurityCode' => 123
    }
  }

  describe '.new' do
    subject(:debit_card) { BraspagRest::CreditCard.new(braspag_response) }

    it 'initializes a debit card using braspag response format' do
      expect(debit_card.expiration_date).to eq('12/2021')
      expect(debit_card.brand).to eq('Visa')
      expect(debit_card.number).to eq('000000******0001')
      expect(debit_card.holder).to eq('Teste Holder')
      expect(debit_card.security_code).to eq(123)
    end
  end
end
