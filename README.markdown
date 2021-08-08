# Resque Slack

A [Resque][rq] plugin. Requires Resque >= 1.19 and a >= 1.9 Ruby (MRI, JRuby or Rubinius).

Post a notification in a [Slack][slack] channel when one your jobs fails.

## Installation

Add this line to your application's Gemfile:

    gem 'resque-slack'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install resque-slack

## Usage

Configure your webhook and notification verbosity:

```ruby
require 'resque/failure/slack'

Resque::Failure::Slack.configure do |config|
  config.webhook = 'WEBHOOK'     # required
  config.level = verbosity_level # optional
end

Resque::Failure.backend = Resque::Failure::Slack

```

Level can be:

- verbose: worker, payload, exception and full backtrace
- compact: worker, payload and exception
- minimal: worker and payload only

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[rq]: http://github.com/julienXX/resque
[slack]: http://slack.com

[![Build Status](https://travis-ci.org/julienXX/resque-slack.svg)](https://travis-ci.org/julienXX/resque-slack) [![Code Climate](https://codeclimate.com/github/julienXX/resque-slack.svg)](https://codeclimate.com/github/julienXX/resque-slack)
