require 'spec_helper'

describe BraspagRest::Request do
  let(:config) { YAML.load(File.read('spec/fixtures/configuration.yml'))['test'] }
  let(:logger) { double }

  before do
    BraspagRest.config do |configuration|
      configuration.config_file_path = 'spec/fixtures/configuration.yml'
      configuration.environment = 'test'
      configuration.logger = logger
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

    context 'when is a successful response' do
      let(:gateway_response) { double(code: 200, body: '{}') }

      it 'calls sale creation with request_id and their parameters' do
        expect(RestClient).to receive(:post).with(sale_url, params.to_json, headers)
        described_class.authorize(request_id, params)
      end

      it 'returns a braspag successful response' do
        allow(RestClient).to receive(:post).and_return(gateway_response)

        response = described_class.authorize(request_id, params)
        expect(response).to be_success
        expect(response.parsed_body).to eq({})
      end
    end

    context 'when is a failure by invalid params' do
      let(:gateway_response) { double(code: 400, body: '{}') }

      it 'returns a braspag unsuccessful response and log it as a warning' do
        allow(RestClient).to receive(:post).and_raise(RestClient::ExceptionWithResponse, gateway_response)
        expect(logger).to receive(:warn).with("[BraspagRest] RestClient::ExceptionWithResponse: {} #slack")

        response = described_class.authorize(request_id, params)
        expect(response).not_to be_success
        expect(response.parsed_body).to eq({})
      end
    end

    context 'when is a failure by unexpected exception' do
      let(:gateway_response) { double(code: 500, body: '{}') }

      it 'raises the exception and log it as an error' do
        allow(RestClient).to receive(:post).and_raise(RestClient::Exception, gateway_response)
        expect(logger).to receive(:error).with("[BraspagRest] RestClient::Exception: {} #slack")

        expect { described_class.authorize(request_id, params) }.to raise_error(RestClient::Exception)
      end
    end
  end
end
