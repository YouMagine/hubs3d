require "json"
require "oauth"

# To help debugging:
# require 'net-http-spy'
# Net::HTTP.http_logger_options = {:verbose => true}

require "hubs3d/configuration"
require "hubs3d/error"

module Hubs3D
  module API
    module_function
    def post(path, params = {})
      consumer = OAuth::Consumer.new(Hubs3D.configuration.oauth_key,
                                     Hubs3D.configuration.oauth_secret,
                                     site: Hubs3D.configuration.api_site)
      token = OAuth::AccessToken.new(consumer)
      response = token.post(Hubs3D.configuration.api_path + path,
                            params,
                            "Accept" => "application/json")

      begin
        result = JSON.parse(response.body)
      rescue
      end

      if (200...300).include?(response.code.to_i)
        result
      else
        fail Error, get_error_message(result, response)
      end
    end

    module_function
    def get_error_message(json_result, response)
      if json_result.kind_of?(Array) && json_result.size == 1
        message = json_result.first
      else
        message = "Unexpected response (body=#{response.body}"
      end

      "#{message} (status code = #{response.code})"
    end
  end
end
