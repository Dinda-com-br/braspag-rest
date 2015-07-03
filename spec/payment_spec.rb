require 'spec_helper'

describe BraspagRest::Payment do
  let(:braspag_response) {
    {
      'ReasonMessage' => 'Successful',
      'Interest' => 'ByMerchant',
      'Links' => [
         {
            'Href' => 'https=>//apiqueryhomolog.braspag.com.br/v2/sales/1ff114b4-32bb-4fe2-b1f2-ef79822ad5e1',
            'Method' => 'GET',
            'Rel' => 'self'
         },
         {
            'Method' => 'PUT',
            'Href' => 'https=>//apihomolog.braspag.com.br/v2/sales/1ff114b4-32bb-4fe2-b1f2-ef79822ad5e1/capture',
            'Rel' => 'capture'
         },
         {
            'Rel' => 'void',
            'Href' => 'https=>//apihomolog.braspag.com.br/v2/sales/1ff114b4-32bb-4fe2-b1f2-ef79822ad5e1/void',
            'Method' => 'PUT'
         }
      ],
      'ServiceTaxAmount' => 0,
      'Country' => 'BRA',
      'AcquirerTransactionId' => '0625101832104',
      'CreditCard' => {
         'ExpirationDate' => '12/2021',
         'SaveCard' => false,
         'Brand' => 'Visa',
         'CardNumber' => '000000******0001',
         'Holder' => 'Teste Holder'
      },
      'ReceivedDate' => '2015-06-25 10=>18=>32',
      'ProviderReturnCode' => '4',
      'ReasonCode' => 0,
      'ProofOfSale' => '1832104',
      'Capture' => false,
      'Provider' => 'Simulado',
      'Currency' => 'BRL',
      'ProviderReturnMessage' => 'Operation Successful',
      'Amount' => 15700,
      'Type' => 'CreditCard',
      'AuthorizationCode' => '058475',
      'PaymentId' => '1ff114b4-32bb-4fe2-b1f2-ef79822ad5e1',
      'Authenticate' => false,
      'Installments' => 1,
      'Recurrent' => false,
      'Status' => 1
    }
  }

  describe '.new' do
    subject(:payment) { BraspagRest::Payment.new(braspag_response) }

    it 'initializes a payment using braspag response format' do
      expect(payment.type).to eq('CreditCard')
      expect(payment.amount).to eq(15700)
      expect(payment.provider).to eq('Simulado')
      expect(payment.installments).to eq(1)
      expect(payment.credit_card).to be_an_instance_of(BraspagRest::CreditCard)
      expect(payment.status).to eq(1)
      expect(payment.id).to eq('1ff114b4-32bb-4fe2-b1f2-ef79822ad5e1')
      expect(payment.transaction_id).to eq('0625101832104')
      expect(payment.authorization_code).to eq('058475')
      expect(payment.reason_code).to eq(0)
      expect(payment.reason_message).to eq('Successful')
    end
  end

  describe '#authorized?' do
    subject(:sale) { BraspagRest::Payment.new(params) }

    context 'when status is 1' do
      let(:params) { { status: 1 } }

      it 'returns authorized' do
        expect(sale).to be_authorized
      end
    end

    context 'when status is not 1' do
      let(:params) { { status: 2 } }

      it 'returns not authorized' do
        expect(sale).not_to be_authorized
      end
    end
  end
end
