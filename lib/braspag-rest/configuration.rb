require 'singleton'
require 'yaml'

module BraspagRest
  class Configuration
    include Singleton

    attr_accessor :environment, :logger, :config_file_path

    def config_file_path
      @config_file_path || 'config/braspag-rest.yml'
    end

    def environment
      @environment || ENV['RACK_ENV'] || ENV['RAILS_ENV'] || raise('You must set the environment!')
    end

    def log_enabled?
      config['log_enable'] && logger
    end

    def url
      config['url']
    end

    def query_url
      config['query_url']
    end

    def merchant_id
      config['merchant_id']
    end

    def merchant_key
      config['merchant_key']
    end

    private

    def config
      @config ||= YAML.load(File.read(config_file_path))[environment]
    end
  end
end
