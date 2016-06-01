require 'spec_helper'

describe BraspagRest::FraudAnalysis do
  let(:params) {
    {
      'Sequence' => 'AuthorizeFirst',
      'SequenceCriteria' => 'Always',
      'CaptureOnLowRisk' => false,
      'VoidOnHighRisk' => false,
      'Browser' => {
        'CookiesAccepted' => false,
        'Email' => 'compradorteste@live.com',
        'HostName' => 'Teste',
        'IpAddress' => '202.190.150.350',
        'Type' => 'Chrome'
      },
      'Cart' => {
        'IsGift' => false,
        'ReturnsAccepted' => true,
        'Items' => [
          {
            'GiftCategory' => 'Undefined',
            'HostHedge' => 'Off',
            'NonSensicalHedge' => 'Off',
            'ObscenitiesHedge' => 'Off',
            'PhoneHedge' => 'Off',
            'Name' => 'ItemTeste',
            'Quantity' => 1,
            'Sku' => '201411170235134521346',
            'UnitPrice' => 123,
            'Risk' => 'High',
            'TimeHedge' => 'Normal',
            'Type' => 'AdultContent',
            'VelocityHedge' => 'High'
          }
        ]
      },
      'MerchantDefinedFields' => [
        {
          'Id' => 9,
          'Value' => 'web'
        }
      ]
    }
  }

  describe '.new' do
    subject(:fraud_analysis) { BraspagRest::FraudAnalysis.new(params) }

    it 'initializes a fraud analysis' do
      expect(fraud_analysis.capture_on_low_risk).to eq(false)
      expect(fraud_analysis.sequence).to eq('AuthorizeFirst')
      expect(fraud_analysis.sequence_criteria).to eq('Always')
      expect(fraud_analysis.void_on_high_risk).to eq(false)

      expect(fraud_analysis.merchant_defined_fields.first.id).to eq(9)
      expect(fraud_analysis.merchant_defined_fields.first.value).to eq('web')

      expect(fraud_analysis.browser.cookies_accepted).to eq(false)
      expect(fraud_analysis.browser.email).to eq('compradorteste@live.com')
      expect(fraud_analysis.browser.host_name).to eq('Teste')
      expect(fraud_analysis.browser.ip_address).to eq('202.190.150.350')
      expect(fraud_analysis.browser.type).to eq('Chrome')

      expect(fraud_analysis.cart.is_gift).to eq(false)
      expect(fraud_analysis.cart.returns_accepted).to eq(true)

      expect(fraud_analysis.cart.items.first.gift_category).to eq('Undefined')
      expect(fraud_analysis.cart.items.first.host_hedge).to eq('Off')
      expect(fraud_analysis.cart.items.first.name).to eq('ItemTeste')
      expect(fraud_analysis.cart.items.first.non_sensical_hedge).to eq('Off')
      expect(fraud_analysis.cart.items.first.obscenities_hedge).to eq('Off')
      expect(fraud_analysis.cart.items.first.phone_hedge).to eq('Off')
      expect(fraud_analysis.cart.items.first.quantity).to eq(1)
      expect(fraud_analysis.cart.items.first.risk).to eq('High')
      expect(fraud_analysis.cart.items.first.sku).to eq('201411170235134521346')
      expect(fraud_analysis.cart.items.first.time_hedge).to eq('Normal')
      expect(fraud_analysis.cart.items.first.type).to eq('AdultContent')
      expect(fraud_analysis.cart.items.first.unit_price).to eq(123)
      expect(fraud_analysis.cart.items.first.velocity_hedge).to eq('High')
    end
  end

  it 'is accepted' do
    fraud_analysis = BraspagRest::FraudAnalysis.new(status: 1)

    expect(fraud_analysis).to be_accepted
    expect(fraud_analysis).not_to be_rejected
  end

  it 'is rejected' do
    fraud_analysis = BraspagRest::FraudAnalysis.new(status: 2)

    expect(fraud_analysis).not_to be_accepted
    expect(fraud_analysis).to be_rejected
  end
end
