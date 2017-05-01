module Faultline
  class SyncSender < Airbrake::SyncSender
    def build_post_request(uri, notice)
      Net::HTTP::Post.new(uri.request_uri).tap do |req|
        req.body = notice.to_json

        req['Content-Type'] = CONTENT_TYPE
        req['X-Api-Key'] = @config.api_key
        req['User-Agent'] =
          "#{Faultline::Notice::NOTIFIER[:name]}/#{Faultline::VERSION}" \
          " Ruby/#{RUBY_VERSION}"
      end
    end
  end
end
