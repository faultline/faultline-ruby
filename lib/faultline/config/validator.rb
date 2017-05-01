module Faultline
  class Config
    class Validator < Airbrake::Config::Validator
      ##
      # @return [String]
      REQUIRED_PROJECT_MSG = ':project is required'.freeze

      ##
      # @return [String]
      REQUIRED_API_KEY_MSG = ':api_key is required'.freeze

      ##
      # @return [String]
      REQUIRED_ENDPOINT_MSG = ':endpoint is required'.freeze

      ##
      # @return [Boolean]
      def valid_project?
        valid = @config.project.is_a?(String) && !@config.project.empty?
        @error_message = REQUIRED_PROJECT_MSG unless valid
        valid
      end

      ##
      # @return [Boolean]
      def valid_api_key?
        valid = @config.api_key.is_a?(String) && !@config.api_key.empty?
        @error_message = REQUIRED_API_KEY_MSG unless valid
        valid
      end

      ##
      # @return [Boolean]
      def valid_endpoint?
        valid = @config.endpoint.is_a?(URI) && !@config.endpoint.to_s.empty?
        @error_message = REQUIRED_ENDPOINT_MSG unless valid
        valid
      end
    end
  end
end
