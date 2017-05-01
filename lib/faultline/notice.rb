module Faultline
  class Notice < Airbrake::Notice
    NOTIFIER = {
      name: 'faultline-ruby'.freeze,
      version: Faultline::VERSION,
      url: 'https://github.com/faultline/faultline-ruby'.freeze
    }.freeze

    CONTEXT = {
      os: RUBY_PLATFORM,
      language: "#{RUBY_ENGINE}/#{RUBY_VERSION}".freeze,
      notifier: NOTIFIER
    }.freeze

    def initialize(config, exception, params = {})
      @config = config

      @payload = {
        errors: Airbrake::NestedException.new(exception, @config.logger).as_json,
        context: context,
        environment: {},
        session: {},
        params: params,
        notifications: @config.notifications
      }
      @stash = {}

      extract_custom_attributes(exception)

      @truncator = Airbrake::PayloadTruncator.new(PAYLOAD_MAX_SIZE, @config.logger)
    end

    def context
      {
        version: @config.app_version,
        # We ensure that root_directory is always a String, so it can always be
        # converted to JSON in a predictable manner (when it's a Pathname and in
        # Rails environment, it converts to unexpected JSON).
        rootDirectory: @config.root_directory.to_s,
        environment: @config.environment,

        # Make sure we always send hostname.
        hostname: HOSTNAME
      }.merge(CONTEXT).delete_if { |_key, val| val.nil? || val.empty? }
    end
  end
end
