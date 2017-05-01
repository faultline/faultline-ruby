module Faultline
  class Notifier < Airbrake::Notifier
    LOG_LABEL = '**Faultline:'.freeze

    def initialize(user_config)
      @config = (user_config.is_a?(Config) ? user_config : Config.new(user_config))

      unless @config.valid?
        raise Airbrake::Error, @config.validation_error_message
      end

      @filter_chain = Airbrake::FilterChain.new(@config)

      add_filters_for_config_keys

      @async_sender = AsyncSender.new(@config)
      @sync_sender = SyncSender.new(@config)
    end

    def build_notice(exception, params = {})
      if @async_sender.closed?
        raise Airbrake::Error,
              "attempted to build #{exception} with closed Airbrake instance"
      end

      if exception.is_a?(Faultline::Notice)
        exception[:params].merge!(params)
        exception
      else
        Faultline::Notice.new(@config, convert_to_exception(exception), params)
      end
    end
  end
end
