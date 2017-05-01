module Faultline
  class Config < Airbrake::Config
    attr_accessor :project
    attr_accessor :api_key
    attr_writer :endpoint
    attr_accessor :notifications

    def initialize(user_config = {})
      super
      @validator = Faultline::Config::Validator.new(self)
    end

    def endpoint
      return nil if @endpoint.nil?
      URI.parse(File.join(@endpoint, '/projects/', "/#{@project}/", '/errors'))
    end

    def valid?
      return true if ignored_environment?
      return false unless @validator.valid_project?
      return false unless @validator.valid_api_key?
      return false unless @validator.valid_endpoint?
      return false unless @validator.valid_environment?

      true
    end
  end
end
