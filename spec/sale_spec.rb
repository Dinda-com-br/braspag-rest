require 'spec_helper'

describe BraspagRest::Sale do
  describe '.new' do
    let(:braspag_response) {
      {
         'Payment' => {
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
         },
         'MerchantOrderId' => '18288',
         'Customer' => {
            'Name' => 'Comprador Teste'
         }
      }
    }

    subject(:sale) { BraspagRest::Sale.new(braspag_response) }

    it 'initializes a sale using braspag response format' do
      expect(sale.order_id).to eq('18288')
      expect(sale.payment).to be_an_instance_of(BraspagRest::Payment)
      expect(sale.customer).to be_an_instance_of(BraspagRest::Customer)
    end
  end

  describe '#save' do
    let(:attributes) {
      {
        order_id: 123456,
        customer: {
          name: 'Maria'
        },
        payment: {
          type: 'CreditCard',
          amount: 15700,
          provider: 'Simulado',
          installments: 1,
          credit_card: {
            number: '0000000000000001',
            holder: 'Maria',
            expiration_date: '12/2012',
            security_code: 123,
            brand: 'Visa'
          }
        }
      }
    }

    before { allow(BraspagRest::Request).to receive(:authorize).and_return(response) }

    subject(:sale) { BraspagRest::Sale.new(attributes) }

    context 'when the gateway returns a successful response' do
      let(:parsed_body) {
        { 'Payment' => { 'Status' => 1, 'PaymentId' => '1ff114b4-32bb-4fe2-b1f2-ef79822ad5e1' } }
      }

      let(:response) { double(success?: true, parsed_body: parsed_body) }

      it 'returns true and fills the sale object with the return' do
        expect(sale.save).to be_truthy
        expect(sale.payment.status).to eq(1)
        expect(sale.payment.id).to eq('1ff114b4-32bb-4fe2-b1f2-ef79822ad5e1')
      end
    end

    context 'when the gateway returns a failure' do
      let(:parsed_body) {
        [{ 'Code' => 123, 'Message' => 'MerchantOrderId cannot be null' }]
      }

      let(:response) { double(success?: false, parsed_body: parsed_body) }

      it 'returns false and fills the errors attribute' do
        expect(sale.save).to be_falsey
        expect(sale.errors).to eq([{ code: 123, message: "MerchantOrderId cannot be null" }])
      end
    end
  end
end
