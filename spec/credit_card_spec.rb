require 'spec_helper'

describe BraspagRest::CreditCard do
  let(:braspag_response) {
    {
       'ExpirationDate' => '12/2021',
       'SaveCard' => false,
       'Brand' => 'Visa',
       'CardNumber' => '000000******0001',
       'Holder' => 'Teste Holder',
       'CardToken' => '123456',
       'SecurityCode' => 123
    }
  }

  describe '.new' do
    subject(:credit_card) { BraspagRest::CreditCard.new(braspag_response) }

    it 'initializes a credit card using braspag response format' do
      expect(credit_card.expiration_date).to eq('12/2021')
      expect(credit_card.saved).to be_falsey
      expect(credit_card.brand).to eq('Visa')
      expect(credit_card.number).to eq('000000******0001')
      expect(credit_card.holder).to eq('Teste Holder')
      expect(credit_card.token).to eq('123456')
      expect(credit_card.security_code).to eq(123)
    end
  end
end
