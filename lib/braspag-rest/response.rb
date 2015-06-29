module BraspagRest
  class Response
    attr_reader :gateway_response

    def initialize(gateway_response)
      @gateway_response = gateway_response
    end

    def success?
      (200..207).include?(@gateway_response.code)
    end

    def parsed_body
      JSON.parse(@gateway_response.body) rescue {}
    end
  end
end
