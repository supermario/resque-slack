require File.join(File.dirname(__FILE__) + '/../../spec_helper')

describe Resque::Failure::Slack do
  context 'configuration' do
    it 'is not configured by default' do
      expect(described_class.configured?).to be_falsey
    end

    it 'fails without webhook' do
      expect {
        Resque::Failure::Slack.configure do |config|
          config.webhook = nil
        end
      }.to raise_error RuntimeError
      expect(described_class.configured?).to be_falsey
    end

    it 'succeed with a webhook' do
      Resque::Failure::Slack.configure do |config|
        config.webhook = 'WEBHOOK'
      end
      expect(described_class.configured?).to be_truthy
    end
  end

  context 'notification verbosity' do
    it 'has a configurable verobosity' do
      slack = described_class.new('exception', 'worker', 'queue', 'payload')

      described_class::LEVELS.each do |level|
        Resque::Failure::Slack.configure do |config|
          config.webhook = 'WEBHOOK'
          config.level = level
        end
        expect(Resque::Failure::Notification).to receive(:generate).with(slack, level)
        slack.text
      end
    end
  end

  context 'save' do
    it 'posts a notification upon save if configured' do
      slack = described_class.new('exception', 'worker', 'queue', 'payload')

      Resque::Failure::Slack.configure do |config|
        config.webhook = 'WEBHOOK'
      end

      expect(slack).to receive(:report_exception)
      slack.save
    end
  end

  context 'report_exception' do
    it 'sends a notification to Slack' do
      slack = described_class.new('exception', 'worker', 'queue', 'payload')
      webhook = 'https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX'

      Resque::Failure::Slack.configure do |config|
        config.webhook = webhook
        config.level = :minimal
      end

      uri = URI.parse(webhook)
      text = Resque::Failure::Notification.generate(slack, :minimal)
      params = { 'text' => text }

      expect(Net::HTTP).to receive(:post_form)
        .with(uri, params)
        .and_return(true)

      slack.report_exception
    end
  end
end
