require 'spec_helper'

RSpec.describe Faultline::Config do
  let(:config) { described_class.new }

  describe '#new' do
    describe 'options' do
      it "doesn't set the default project" do
        expect(config.project).to be_nil
      end

      it "doesn't set the default api_key" do
        expect(config.api_key).to be_nil
      end

      it "doesn't set the default proxy" do
        expect(config.proxy).to be_empty
      end

      it 'sets the default logger' do
        expect(config.logger).to be_a Logger
      end

      it "doesn't set the default app_version" do
        expect(config.app_version).to be_nil
      end

      it "doesn't set the default endpoint" do
        expect(config.endpoint).to be_nil
      end

      it 'creates a new Config and merges it with the user config' do
        cfg = described_class.new(logger: StringIO.new)
        expect(cfg.logger).to be_a StringIO
      end

      it 'raises error on unknown config options' do
        expect { described_class.new(unknown_option: true) }.to raise_error(Airbrake::Error, /unknown option/)
      end

      it 'sets the default number of workers' do
        expect(config.workers).to eq(1)
      end

      it 'sets the default number of queue size' do
        expect(config.queue_size).to eq(100)
      end

      it 'sets the default root_directory' do
        expect(config.root_directory).to eq Bundler.root.realpath.to_s
      end

      it "doesn't set the default environment" do
        expect(config.environment).to be_nil
      end

      it "doesn't set default notify_environments" do
        expect(config.ignore_environments).to be_empty
      end

      it "doesn't set default timeout" do
        expect(config.timeout).to be_nil
      end

      it "doesn't set default blacklist" do
        expect(config.blacklist_keys).to be_empty
      end

      it "doesn't set default whitelist" do
        expect(config.whitelist_keys).to be_empty
      end
    end
  end

  describe '#valid?' do
    context 'when project is nil' do
      it 'returns false' do
        config.project = nil
        config.api_key = '123'
        config.endpoint = 'https://api.example.com/v0'

        expect(config).not_to be_valid
      end
    end

    context 'when api_key is nil' do
      it 'returns false' do
        config.project = 'faultine'
        config.api_key = nil
        config.endpoint = 'http://api.example.com/v0'

        expect(config).not_to be_valid
      end
    end

    context 'when endpoint is nil' do
      it 'returns false' do
        config.project = 'faultine'
        config.api_key = '123'
        config.endpoint = nil

        expect(config).not_to be_valid
      end
    end

    context 'when the current environment is ignored' do
      context 'and when the notifier misconfigures configure project, api_key & endpoint' do
        it 'returns true' do
          config.project = Object.new
          config.api_key = Object.new
          config.endpoint = Object.new
          config.environment = :bingo
          config.ignore_environments = [:bingo]

          expect(config).to be_valid
        end
      end

      context 'and when the notifier configures project, api_key & endpoint' do
        it 'returns true' do
          config.project = 'endpoint'
          config.api_key = '321'
          config.endpoint = 'https://api.example.com/v0'
          config.environment = :bingo
          config.ignore_environments = [:bingo]

          expect(config).to be_valid
        end
      end
    end

    context 'when the project value is not a String' do
      it 'returns false' do
        config.project = 12_345
        config.api_key = '123'
        config.endpoint = 'https://api.example.com/v0'

        expect(config).not_to be_valid
      end
    end

    context 'when the api_key value is an empty String' do
      it 'returns false' do
        config.project = 'faultline'
        config.api_key = ''
        config.endpoint = 'https://api.example.com/v0'

        expect(config).not_to be_valid
      end
    end
  end
end
