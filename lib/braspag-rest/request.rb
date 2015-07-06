module BraspagRest
  class Request
    class << self
      SALE_ENDPOINT = '/v2/sales/'
      VOID_ENDPOINT = '/void'

      def authorize(request_id, params)
        gateway_response = RestClient.post(sale_url, params.to_json, default_headers.merge('RequestId' => request_id))
        BraspagRest::Response.new(gateway_response)
      rescue RestClient::ExceptionWithResponse => e
        config.logger.warn("[BraspagRest] #{e}") if config.log_enabled?
        BraspagRest::Response.new(e.response)
      rescue RestClient::Exception => e
        config.logger.error("[BraspagRest] #{e}") if config.log_enabled?
        raise
      end

      def void(request_id, payment_id, amount)
        params = { Amount: amount }.to_json
        gateway_response = RestClient.put(void_url(payment_id), params, default_headers.merge('RequestId' => request_id))
        BraspagRest::Response.new(gateway_response)
      rescue RestClient::ExceptionWithResponse => e
        config.logger.warn("[BraspagRest] #{e}") if config.log_enabled?
        BraspagRest::Response.new(e.response)
      rescue RestClient::Exception => e
        config.logger.error("[BraspagRest] #{e}") if config.log_enabled?
        raise
      end

      private

      def sale_url
        config.url + SALE_ENDPOINT
      end

      def void_url(payment_id)
        sale_url + payment_id.to_s + VOID_ENDPOINT
      end

      def default_headers
        {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'MerchantId' => config.merchant_id,
          'MerchantKey' => config.merchant_key
        }
      end

      def config
        @config ||= BraspagRest::Configuration.instance
      end
    end
  end
end
