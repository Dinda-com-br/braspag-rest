require 'spec_helper'

describe BraspagRest::Response do
  describe '#success' do
    context 'when gateway status code is 200..207' do
      it 'returns true' do
        (200..207).each do |code|
          gateway_response = Hashie::Mash.new(code: code, body: '{}')
          expect(BraspagRest::Response.new(gateway_response)).to be_success
        end
      end
    end

    context 'when gateway status code is not 200..207' do
      let(:gateway_response) { Hashie::Mash.new(code: 400, body: '{}') }

      it 'returns false' do
        expect(BraspagRest::Response.new(gateway_response)).not_to be_success
        gateway_response.code = 500
        expect(BraspagRest::Response.new(gateway_response)).not_to be_success
      end
    end

    context 'when gateway returns an error' do
      let(:gateway_response) { Hashie::Mash.new(body: 'an error happened') }

      it 'returns false' do
        expect(BraspagRest::Response.new(gateway_response)).not_to be_success
      end
    end
  end

  describe '#parsed_body' do
    let(:gateway_response) { Hashie::Mash.new(code: 200, body: '{"Name" : "Maria"}') }

    subject(:response) { BraspagRest::Response.new(gateway_response) }

    it 'returns the body gateway response as a hash' do
      expect(response.parsed_body).to eq({ 'Name' => 'Maria' })
    end
  end
end
