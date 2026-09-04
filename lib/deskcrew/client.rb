# frozen_string_literal: true

require "json"
require "net/http"
require "uri"

module Deskcrew
  # Two calls, both plain HTTPS to DeskCrew:
  #   Deskcrew::Client.register_origin   -> lets the widget run on config.site_url
  #   Deskcrew::Client.create_ticket(...) -> a support ticket from your own code
  # Both are best-effort: a network failure returns false, never raises into your app.
  class Client
    TIMEOUT = 10

    class << self
      def register_origin(config = Deskcrew.config, http: nil)
        return false unless config.widget_ready? && config.site_url.to_s.start_with?("https://")

        post(config, "/api/widget/register-origin", { key: config.widget_key, origin: config.site_url }, http: http)
      end

      def create_ticket(name: nil, email:, message:, config: Deskcrew.config, http: nil)
        return false unless config.widget_ready?
        return false if email.to_s.strip.empty? || message.to_s.strip.empty?

        post(
          config,
          "/api/widget/submit",
          { key: config.widget_key, name: name.to_s, email: email.to_s, message: message.to_s },
          origin: config.site_url,
          http: http
        )
      end

      private

      def post(config, path, payload, origin: nil, http: nil)
        uri = URI.join(config.app_url, path)
        request = Net::HTTP::Post.new(uri)
        request["Content-Type"] = "application/json"
        request["Origin"] = origin if origin
        request.body = JSON.generate(payload)

        client = http || Net::HTTP.new(uri.host, uri.port).tap do |c|
          c.use_ssl = uri.scheme == "https"
          c.open_timeout = TIMEOUT
          c.read_timeout = TIMEOUT
        end
        response = client.request(request)
        response.code.to_i.between?(200, 299)
      rescue StandardError
        false
      end
    end
  end
end
