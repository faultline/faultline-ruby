require 'airbrake-ruby'
require 'faultline/version'
require 'faultline/config'
require 'faultline/config/validator'
require 'faultline/notifier'
require 'faultline/notice'
require 'faultline/sync_sender'
require 'faultline/async_sender'

module Faultline
  class NilNotifier
    def notify(_exception, _params = {}); end

    def notify_sync(_exception, _params); end

    def add_filter(_filter = nil, &_block); end

    def build_notice(_exception, _params); end

    def close; end

    def create_deploy(_deploy_params); end
  end

  Error = Class.new(StandardError)

  LOG_LABEL = '**Faultline:'.freeze

  RUBY_20 = RUBY_VERSION.start_with?('2.0')

  @notifiers = Hash.new(NilNotifier.new)

  class << self
    def [](notifier_name)
      @notifiers[notifier_name]
    end

    def configure(notifier_name = :default)
      yield config = Faultline::Config.new

      if @notifiers.key?(notifier_name)
        raise Airbrake::Error,
              "the '#{notifier_name}' notifier was already configured"
      else
        @notifiers[notifier_name] = Notifier.new(config)
      end
    end

    def notify(exception, params = {})
      @notifiers[:default].notify(exception, params)
    end

    def notify_sync(exception, params = {})
      @notifiers[:default].notify_sync(exception, params)
    end

    def add_filter(filter = nil, &block)
      @notifiers[:default].add_filter(filter, &block)
    end

    def build_notice(exception, params = {})
      @notifiers[:default].build_notice(exception, params)
    end

    def close
      @notifiers[:default].close
    end

    def create_deploy(deploy_params)
      @notifiers[:default].create_deploy(deploy_params)
    end
  end
end
