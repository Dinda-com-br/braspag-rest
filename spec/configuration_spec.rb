require 'spec_helper'

describe BraspagRest::Configuration do
  context 'when there is custom configuration file and environment name' do
    subject(:configuration) { BraspagRest::Configuration.new }

    it 'configures the gem using values from configuration file' do
      configuration.config_file_path = 'spec/fixtures/configuration.yml'
      configuration.environment = 'test'

      expect(configuration.config_file_path).to eq('spec/fixtures/configuration.yml')
      expect(configuration.environment).to eq('test')
      expect(configuration.url).to eq('https://apisandbox.braspag.com.br')
      expect(configuration.query_url).to eq('https://apiquerysandbox.braspag.com.br')
      expect(configuration.merchant_id).to eq('12345678-1234-1234-1234-123456789012')
      expect(configuration.merchant_key).to eq('1234567890123456789012345678901234567890')
    end
  end

  context 'default configuration' do
    subject(:configuration) { BraspagRest::Configuration.new }

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

  context 'when the config file has ERB blocks' do
    subject(:configuration) { BraspagRest::Configuration.new }

    it 'processes the ERB code before parsing the configuration' do
      configuration.config_file_path = 'spec/fixtures/configuration.yml'
      configuration.environment = 'production'

      ENV['BRASPAG_MERCHANT_KEY'] = 'MERCHANT_KEY_SET_THROUGH_ENV'
      expect(configuration.merchant_key).to eq('MERCHANT_KEY_SET_THROUGH_ENV')
    end
  end
end
