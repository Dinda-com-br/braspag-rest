require 'spec_helper'

describe BraspagRest::Request do
  let(:config) { YAML.load(File.read('spec/fixtures/configuration.yml'))['test'] }

  before do
    BraspagRest.config do |configuration|
      configuration.config_file_path = 'spec/fixtures/configuration.yml'
      configuration.environment = 'test'
    end
  end

  describe '.authorize' do
    let(:sale_url) { config['url'] + '/v2/sales/' }
    let(:request_id) { '30000000-0000-0000-0000-000000000001' }

    let(:headers) {
      {
        'Content-Type' => 'application/json',
        'MerchantId' => config['merchant_id'],
        'MerchantKey' => config['merchant_key'],
        'RequestId' => request_id
      }
    }

    let(:params) {
      {
        'Customer' => { 'Name' => 'Maria' }
      }
    }

    it 'calls sale creation with request_id and their parameters' do
      expect(RestClient).to receive(:post).with(sale_url, params.to_json, headers)
      described_class.authorize(request_id, params)
    end
  end
end
