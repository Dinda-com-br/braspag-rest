module BraspagRest
  class Request
    class << self
      SALE_ENDPOINT = '/v2/sales/'
      VOID_ENDPOINT = '/void'
      CAPTURE_ENDPOINT = '/capture'

      def authorize(request_id, params)
        config.logger.info("[BraspagRest][Authorize] endpoint: #{sale_url}, params: #{params.to_json}") if config.log_enabled?

        execute_braspag_request do
          RestClient::Request.execute(
            method: :post,
            url: sale_url,
            payload: params.to_json,
            headers: default_headers.merge('RequestId' => request_id),
            timeout: config.request_timeout
          )
        end
      end

      def void(request_id, payment_id, amount)
        config.logger.info("[BraspagRest][Void] endpoint: #{void_url(payment_id, amount)}") if config.log_enabled?

        execute_braspag_request do
          RestClient::Request.execute(
            method: :put,
            url: void_url(payment_id, amount),
            headers: default_headers.merge('RequestId' => request_id),
            timeout: config.request_timeout
          )
        end
      end

      def get_sale(request_id, payment_id)
        config.logger.info("[BraspagRest][GetSale] endpoint: #{search_sale_url(payment_id)}") if config.log_enabled?

        execute_braspag_request do
          RestClient::Request.execute(
            method: :get,
            url: search_sale_url(payment_id),
            headers: default_headers.merge('RequestId' => request_id),
            timeout: config.request_timeout
          )
        end
      end

      def get_sales_for_merchant_order_id(request_id, merchant_order_id)
        config.logger.info("[BraspagRest][GetSale] endpoint: #{search_sales_for_merchant_order_id_url(merchant_order_id)}") if config.log_enabled?

        execute_braspag_request do
          RestClient::Request.execute(
            method: :get,
            url: search_sales_for_merchant_order_id_url(merchant_order_id),
            headers: default_headers.merge('RequestId' => request_id),
            timeout: config.request_timeout
          )
        end
      end

      def capture(request_id, payment_id, amount)
        config.logger.info("[BraspagRest][Capture] endpoint: #{capture_url(payment_id)}, amount: #{amount}") if config.log_enabled?

        execute_braspag_request do
          RestClient::Request.execute(
            method: :put,
            url: capture_url(payment_id),
            payload: { Amount: amount }.to_json,
            headers: default_headers.merge('RequestId' => request_id),
            timeout: config.request_timeout
          )
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
      rescue RestClient::RequestTimeout => e
        config.logger.error("[BraspagRest][Timeout] message: #{e.message}") if config.log_enabled?
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

      def search_sales_for_merchant_order_id_url(merchant_order_id)
        url = URI.parse(config.query_url)
        url.path = SALE_ENDPOINT
        url.query = "merchantOrderId=#{merchant_order_id}"
        url.to_s
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
