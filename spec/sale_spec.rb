require 'spec_helper'

describe BraspagRest::Sale do
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

  describe '.new' do
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

  describe '#cancel' do
    subject(:sale) { BraspagRest::Sale.new(request_id: 'xxx-xxx-xxx', payment: { id: 123, amount: 1000 }) }

    context "when no amount is given" do
      before do
        allow(BraspagRest::Request).to receive(:void).with('xxx-xxx-xxx', 123, nil)
          .and_return(double(success?: true, parsed_body: {}))
      end

      it 'calls braspag gateway with request_id, payment_id and no payment amount' do
        expect(BraspagRest::Request).to receive(:void).with('xxx-xxx-xxx', 123, nil).and_return(double(success?: true, parsed_body: {}))
        sale.cancel
      end

      it "updates the sale's voided amount with the full transaction amount" do
        sale.cancel
        expect(sale.payment.voided_amount).to eq(1000)
      end

      it "reports success" do
        expect(sale.cancel).to be_truthy
      end
    end

    context "when an amount is given" do
      before do
        allow(BraspagRest::Request).to receive(:void).with('xxx-xxx-xxx', 123, 500)
          .and_return(double(success?: true, parsed_body: {}))
      end

      it 'calls braspag gateway with request_id, payment_id and amount parameter' do
        expect(BraspagRest::Request).to receive(:void).with('xxx-xxx-xxx', 123, 500).and_return(double(success?: true, parsed_body: {}))
        sale.cancel(500)
      end

      it "updates the sale's voided amount with the requested refund amount" do
        sale.cancel(500)
        expect(sale.payment.voided_amount).to eq(500)
      end

      it "reports success" do
        expect(sale.cancel(500)).to be_truthy
      end

      context "and some amount has already been refunded" do
        before { sale.payment.voided_amount = 300 }

        it "updates the sale's voided amount with the summed refund amount" do
          sale.cancel(500)
          expect(sale.payment.voided_amount).to eq(800)
        end
      end
    end

    context 'when the gateway returns a failure' do
      let(:parsed_body) {
        [{ 'Code' => 123, 'Message' => 'Amount cannot be null' }]
      }

      let(:response) { double(success?: false, parsed_body: parsed_body) }

      before { allow(BraspagRest::Request).to receive(:void).and_return(response) }

      it 'returns false and fills the errors attribute' do
        expect(sale.cancel).to be_falsey
        expect(sale.errors).to eq([{ code: 123, message: "Amount cannot be null" }])
      end
    end
  end

  describe '#capture' do
    subject(:sale) { BraspagRest::Sale.new(request_id: 'xxx-xxx-xxx', payment: { id: 123, amount: 1000 }) }

    it 'calls braspag gateway with request_id, payment_id and payment amount' do
      expect(BraspagRest::Request).to receive(:capture).with('xxx-xxx-xxx', 123, 1000).and_return(double(success?: true, parsed_body: {}))

      sale.capture
    end

    it 'calls braspag gateway with request_id, payment_id and amount parameter if it is not nil' do
      expect(BraspagRest::Request).to receive(:capture).with('xxx-xxx-xxx', 123, 500).and_return(double(success?: true, parsed_body: {}))

      sale.capture(500)
    end

    context 'when the gateway returns a successful response' do
      let(:parsed_body) {
        { 'Status' => 2 }
      }

      let(:response) { double(success?: true, parsed_body: parsed_body) }

      before { allow(BraspagRest::Request).to receive(:capture).and_return(response) }

      it 'returns true and fills the sale object with the return' do
        expect(sale.capture).to be_truthy
        expect(sale.payment.status).to eq(2)
        expect(sale.payment.id).to eq(123)
        expect(sale.payment.amount).to eq(1000)
      end
    end

    context 'when the gateway returns a failure' do
      let(:parsed_body) {
        [{ 'Code' => 123, 'Message' => 'Amount cannot be null' }]
      }

      let(:response) { double(success?: false, parsed_body: parsed_body) }

      before { allow(BraspagRest::Request).to receive(:capture).and_return(response) }

      it 'returns false and fills the errors attribute' do
        expect(sale.capture).to be_falsey
        expect(sale.errors).to eq([{ code: 123, message: "Amount cannot be null" }])
      end
    end
  end

  describe '.find' do
    before { allow(BraspagRest::Request).to receive(:get_sale).and_return(double(parsed_body: braspag_response)) }

    it 'calls braspag gateway with request_id and payment_id' do
      expect(BraspagRest::Request).to receive(:get_sale).with('xxx-xxx-xxx', 123).and_return(double(parsed_body: braspag_response))

      BraspagRest::Sale.find('xxx-xxx-xxx', 123)
    end

    it 'returns a populated sales object' do
      sale = BraspagRest::Sale.find('xxx-xxx-xxx', 123)
      expect(sale.order_id).to eq('18288')
      expect(sale.payment).to be_an_instance_of(BraspagRest::Payment)
      expect(sale.customer).to be_an_instance_of(BraspagRest::Customer)
      expect(sale.request_id).to eq('xxx-xxx-xxx')
    end
  end

  describe '.find_by_order_id' do
    let(:request_id) { SecureRandom.uuid }
    let(:order_id) { '1234567890' }

    before do
      allow(BraspagRest::Request).to receive(:get_sales_for_merchant_order_id).and_return(
        double(parsed_body: { 'Payments' => [{ 'PaymentId' => '1234567'}] })
      )

      allow(BraspagRest::Sale).to receive(:find).and_return BraspagRest::Sale.new
    end

    subject { BraspagRest::Sale.find_by_order_id(request_id, order_id) }

    it 'filters all sales for an order_id' do
      expect(BraspagRest::Request).to receive(:get_sales_for_merchant_order_id).with(request_id, order_id)
      subject
    end

    it 'returns a list of BraspagRest::Sale' do
      is_expected.to be_an Array
      expect(subject.all? { |payment| payment.is_a?(BraspagRest::Sale) }).to be_truthy
    end

    context 'when no result is returned' do
      before do
        allow(BraspagRest::Request).to receive(:get_sales_for_merchant_order_id).and_return(
          double(parsed_body: { 'Payments' => nil })
        )
      end

      it 'returns an empty list' do
        is_expected.to be_an Array
        is_expected.to be_empty
      end
    end
  end

  describe '#reload' do
    before { allow(BraspagRest::Request).to receive(:get_sale).and_return(double(parsed_body: braspag_response)) }

    it 'returns itself if request_id or payment_id is blank' do
      sale = BraspagRest::Sale.new
      expect(sale.reload).to eq(sale)

      sale.request_id = 'xxxx-xxxx-xxxx-xxx'
      expect(sale.reload).to eq(sale)

      sale.payment = { id: 123 }
      sale.request_id = nil
      expect(sale.reload).to eq(sale)
    end

    it 'returns a new object loaded from braspag find' do
      sale = BraspagRest::Sale.new(request_id: 'xxxxx-xxxxx-xxxxx-xxxxx', payment: { id: 123 })
      sale = sale.reload
      expect(sale.order_id).to eq('18288')
      expect(sale.payment).to be_an_instance_of(BraspagRest::Payment)
      expect(sale.customer).to be_an_instance_of(BraspagRest::Customer)
    end
  end
end
