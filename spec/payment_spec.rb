require 'spec_helper'

describe BraspagRest::Payment do
  let(:credit_card_payment) {
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
      'CapturedAmount' => 15800,
      'Type' => 'CreditCard',
      'AuthorizationCode' => '058475',
      'PaymentId' => '1ff114b4-32bb-4fe2-b1f2-ef79822ad5e1',
      'Authenticate' => false,
      'Installments' => 1,
      'Recurrent' => false,
      'Status' => 1
    }
  }

  let(:boleto_payment) {
    {
      'Address' => 'N/A, 1',
      'Amount' => 1150,
      'Assignor' => 'Desenvolvedores',
      'BarCodeNumber' => '00093657200000011509999250000000000799999990',
      'BoletoNumber' => '7-4',
      'Country' => 'BRA',
      'Currency' => 'BRL',
      'Demostrative' => '',
      'DigitableLine' => '00099.99921 50000.000005 07999.999902 3 65720000001150',
      'ExpirationDate' => '2015-10-05',
      'Identification' => 'N/A',
      'Instructions' => 'Não pagar após o vencimento.',
      'Links' => [
        {
          'Href' => 'https://apiquerysandbox.braspag.com.br/v2/sales/795cc546-8d3c-4ff3-8548-77320fc4b595',
          'Method' => 'GET',
          'Rel' => 'self'
        }
      ],
      'PaymentId' => '795cc546-8d3c-4ff3-8548-77320fc4b595',
      'Provider' => 'Simulado',
      'ReasonCode' => 0,
      'ReceivedDate' => '2015-10-02 13:11:01',
      'Status' => 1,
      'Type' => 'Boleto',
      'Url' => 'https://sandbox.pagador.com.br/post/pagador/reenvia.asp/795cc546-8d3c-4ff3-8548-77320fc4b595'
    }
  }

  describe '.new' do
    subject(:payment) { BraspagRest::Payment.new(credit_card_payment) }

    it 'initializes a payment using braspag response format' do
      expect(payment.type).to eq('CreditCard')
      expect(payment.amount).to eq(15700)
      expect(payment.captured_amount).to eq(15800)
      expect(payment.provider).to eq('Simulado')
      expect(payment.installments).to eq(1)
      expect(payment.credit_card).to be_an_instance_of(BraspagRest::CreditCard)
      expect(payment.status).to eq(1)
      expect(payment.id).to eq('1ff114b4-32bb-4fe2-b1f2-ef79822ad5e1')
      expect(payment.transaction_id).to eq('0625101832104')
      expect(payment.proof_of_sale).to eq('1832104')
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

  describe '#captured?' do
    subject(:sale) { BraspagRest::Payment.new(params) }

    context 'when status is 2' do
      let(:params) { { status: 2 } }

      it 'returns captured' do
        expect(sale).to be_captured
      end
    end

    context 'when status is not 2' do
      let(:params) { { status: 3 } }

      it 'returns not captured' do
        expect(sale).not_to be_captured
      end
    end
  end

  describe '#cancelled?' do
    subject(:sale) { BraspagRest::Payment.new(params) }

    context 'when status is 10' do
      let(:params) { { status: 10 } }

      it 'returns cancelled' do
        expect(sale).to be_cancelled
      end
    end

    context 'when status is not 10' do
      let(:params) { { status: 3 } }

      it 'returns not cancelled' do
        expect(sale).not_to be_cancelled
      end
    end
  end

  describe 'boleto payments' do
    subject(:payment) { BraspagRest::Payment.new(boleto_payment) }

    it 'features boleto-specific attributes' do
      expect(payment.digitable_line).to eq('00099.99921 50000.000005 07999.999902 3 65720000001150')
      expect(payment.barcode_number).to eq('00093657200000011509999250000000000799999990')
      expect(payment.expiration_date).to eq('2015-10-05')
      expect(payment.instructions).to eq('Não pagar após o vencimento.')
      expect(payment.printable_page_url).to eq('https://sandbox.pagador.com.br/post/pagador/reenvia.asp/795cc546-8d3c-4ff3-8548-77320fc4b595')
      expect(payment.boleto_number).to eq('7-4')
    end
  end
end
