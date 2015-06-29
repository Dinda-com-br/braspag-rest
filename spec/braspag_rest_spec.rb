require 'spec_helper'

describe BraspagRest do
  describe '.config' do
    context 'when there is a block to configure the gem' do
      subject(:configuration) { BraspagRest::Configuration.instance }

      it 'configures the gem using values from configuration file' do
        BraspagRest.config do |config|
          config.config_file_path = 'spec/fixtures/configuration.yml'
          config.environment = 'test'
        end

        expect(configuration.config_file_path).to eq('spec/fixtures/configuration.yml')
        expect(configuration.environment).to eq('test')
        expect(configuration.url).to eq('https://apisandbox.braspag.com.br')
        expect(configuration.query_url).to eq('https://apiquerysandbox.braspag.com.br')
        expect(configuration.merchant_id).to eq('12345678-1234-1234-1234-123456789012')
        expect(configuration.merchant_key).to eq('1234567890123456789012345678901234567890')
      end
    end

    context 'when there is no block to configure the gem' do
      subject(:configuration) { BraspagRest::Configuration.clone.instance }

      it 'returns a instance of braspag configuration with default config file path' do
        expect(configuration.config_file_path).to eq('config/braspag-rest.yml')
      end

      it 'sets RACK_ENV variable value as environment if is filled' do
        ENV['RACK_ENV'] = 'production'
        ENV['RAILS_ENV'] = nil
        expect(configuration.environment).to eq('production')
      end

      it 'sets RAILS_ENV variable value as environment if is filled' do
        ENV['RAILS_ENV'] = 'qa'
        ENV['RACK_ENV'] = nil
        expect(configuration.environment).to eq('qa')
      end
    end
  end
end
