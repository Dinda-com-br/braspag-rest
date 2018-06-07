require 'json'
module BraspagRest
  class Request
    class << self
      SALE_ENDPOINT = '/v2/sales/'
      VOID_ENDPOINT = '/void'
      CAPTURE_ENDPOINT = '/capture'

      def authorize(request_id, params)
        config.logger.info("[BraspagRest][Authorize] endpoint: #{sale_url}, params: #{params.to_json}") if config.log_enabled?

        execute_braspag_request do
          RestClient.post(sale_url, params.to_json, default_headers.merge('RequestId' => request_id))
        end
      end

      def void(request_id, payment_id, amount)
        config.logger.info("[BraspagRest][Void] endpoint: #{void_url(payment_id, amount)}") if config.log_enabled?

        execute_braspag_request do
          RestClient.put(void_url(payment_id, amount), nil, default_headers.merge('RequestId' => request_id))
        end
      end

      def get_sale(request_id, payment_id)
        config.logger.info("[BraspagRest][GetSale] endpoint: #{search_sale_url(payment_id)}") if config.log_enabled?

        execute_braspag_request do
          RestClient.get(search_sale_url(payment_id), default_headers.merge('RequestId' => request_id))
        end
      end

      def capture(request_id, payment_id, amount)
        config.logger.info("[BraspagRest][Capture] endpoint: #{capture_url(payment_id)}, amount: #{amount}") if config.log_enabled?

        execute_braspag_request do
          RestClient.put(capture_url(payment_id), { Amount: amount }.to_json, default_headers.merge('RequestId' => request_id))
        end
      end

      private

      def execute_braspag_request(&block)
        gateway_response = block.call

        config.logger.info("[BraspagRest][Response] gateway_response: #{gateway_response.inspect}") if config.log_enabled?

        BraspagRest::Response.new(gateway_response)
      rescue RestClient::ResourceNotFound => e
        config.logger.error("[BraspagRest][Error] message: #{e.message}, status: #{e.http_code}, body: #{e.http_body.inspect}") if config.log_enabled?
        raise
      rescue RestClient::ExceptionWithResponse => e
        config.logger.warn("[BraspagRest][Error] message: #{e.message}, status: #{e.http_code}, body: #{e.http_body.inspect}") if config.log_enabled?
        BraspagRest::Response.new(e.response)
      rescue RestClient::Exception => e
        config.logger.error("[BraspagRest][Error] message: #{e.message}, status: #{e.http_code}, body: #{e.http_body.inspect}") if config.log_enabled?
        raise
      end

      def sale_url
        config.url + SALE_ENDPOINT
      end

      def void_url(payment_id, amount)
        sale_url + payment_id.to_s + VOID_ENDPOINT + (amount ? "?amount=#{amount}" : '')
      end

      def search_sale_url(payment_id)
        config.query_url + SALE_ENDPOINT + payment_id.to_s
      end

      def capture_url(payment_id)
        sale_url + payment_id.to_s + CAPTURE_ENDPOINT
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
        @config ||= BraspagRest.config
      end
    end
  end
end
