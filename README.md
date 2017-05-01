# faultline-ruby

> [faultline](https://github.com/faultline/faultline) exception and error notifier for Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'faultline'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install faultline

## Usage

```ruby
require 'faultline'

# Every Faultline notifier must configure
# 3 options: `project`, `api_key` and `endpoint`.
# And `notifications` for notificatins (Slack, GitHub Issue)
Faultline.configure do |c|
  c.project = 'faultline-ruby'
  c.api_key = 'xxxxXXXXXxXxXXxxXXXXXXXxxxxXXXXXX'
  c.endpoint = 'https://xxxxxxxxx.execute-api.ap-northeast-1.amazonaws.com/v0'
  c.notifications = [
    {
      type: 'slack',
      endpoint: 'https://hooks.slack.com/services/XXXXXXXXXX/B2RAD9423/WC2uTs3MyGldZvieAtAA7gQq'
      channel: '#random',
      username: 'faultline-notify',
      notifyInterval: 1,
      threshold: 1,
      timezone: 'Asia/Tokyo'
    },
    {
      type: 'github',
      userToken: 'XXXXXXXxxxxXXXXXXxxxxxXXXXXXXXXX',
      owner: 'k1LoW',
      repo: 'faultline',
      labels: [
        'faultline', 'bug'
      ],
      if_exist: 'reopen-and-comment',
      notifyInterval: 1,
      threshold: 1,
      timezone: 'Asia/Tokyo'
    }
  ]
end

# Asynchronous error delivery.
begin
  1/0
rescue ZeroDivisionError => ex
  # Return value is always `nil`.
  Faultline.notify(ex)
end

puts 'A ZeroDivisionError was sent to Faultline asynchronously!'

# Synchronous error delivery.
begin
  1/0
rescue ZeroDivisionError => ex
  # Return value is a Hash.
  response = Faultline.notify_sync(ex)
end

puts "\nAnother ZeroDivisionError was sent to Faultline, but this time synchronously."
```

## References

- [airbrake/airbrake-ruby](https://github.com/airbrake/airbrake-ruby)
    - Airbrake Ruby is licensed under [The MIT License (MIT)](https://github.com/airbrake/airbrake-ruby/LICENSE.md).

## License

MIT © Ken&#39;ichiro Oyama
