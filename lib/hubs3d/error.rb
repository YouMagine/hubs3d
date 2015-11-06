module Hubs3D
  class Error < ::StandardError
    def initialize(parsed_json_result, response)
      if parsed_json_result.kind_of?(Array) && parsed_json_result.size == 1
        message = parsed_json_result.first
      else
        message = "Unexpected response (body=#{response.body}"
      end

      super("#{message} (status code = #{response.code})")
    end
  end
end
