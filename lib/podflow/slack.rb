module Podflow
  class Slack
    attr_reader :username, :channel, :template

    def initialize(data = {})
      @url = data["url"] || "http://fixme.com"
      @username = data["username"] || "Andy"
      @channel = data["channel"] || "@andy"
      @template = data["template"] || "MySlackTemplateFile"
    end

    def send(series, episode)
      payload = {
        username: @username,
        channel: @channel,
        text: body(series, episode)
      }.to_json

      HTTParty.post(
        @url,
        body: payload,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    private

    def body(series, episode)
      ERB.new(PodUtils.local_template_string(@template)).result(binding)
    end
  end
end
