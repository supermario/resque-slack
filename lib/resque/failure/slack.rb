require 'resque'
require 'uri'
require 'net/http'

module Resque
  module Failure
    class Slack < Base
      LEVELS = %i(verbose compact minimal)

      class << self
        attr_accessor :webhook # Slack incoming webhool

        # Notification style:
        #
        # verbose: full backtrace (default)
        # compact: exception only
        # minimal: worker and payload
        attr_accessor :level

        def level
          @level && LEVELS.include?(@level) ? @level : :verbose
        end
      end

      # Configures the failure backend. You will need to set
      # the slack incoming webhook.
      #
      # @example Configure your Slack account:
      #   Resque::Failure::Slack.configure do |config|
      #     config.webhook = 'WEBHOOK'
      #     config.level = 'verbose', 'compact' or 'minimal'
      #   end
      def self.configure
        yield self
        fail 'Slack channel and token are not configured.' unless configured?
      end

      def self.configured?
        !!webhook
      end

      # Sends the exception data to the Slack channel.
      #
      # When a job fails, a new instance is created and #save is called.
      def save
        return unless self.class.configured?

        report_exception
      end

      # Sends a HTTP Post to the Slack api.
      #
      def report_exception
        uri = URI.parse(self.class.webhook)
        params = { 'text' => text }
        Net::HTTP.post(uri, params.to_json, "Content-Type" => "application/json")
      end

      # Text to be displayed in the Slack notification
      #
      def text
        Notification.generate(self, self.class.level)
      end
    end
  end
end

