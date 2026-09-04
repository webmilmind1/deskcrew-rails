# frozen_string_literal: true

module Deskcrew
  # Opt-in (config.auto_inject = true): adds the widget tag before </body> on successful
  # HTML responses. Skips responses that already carry the tag, non-HTML bodies, and
  # anything that is not a 200, so JSON, redirects, streams and errors are untouched.
  class Middleware
    MARKER = "desk.js"

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      return [status, headers, body] unless inject?(status, headers)

      tag = Deskcrew::Widget.tag
      return [status, headers, body] if tag.empty?

      html = +""
      body.each { |part| html << part.to_s }
      body.close if body.respond_to?(:close)
      return [status, headers, [html]] if html.include?(MARKER)

      injected = html.sub(%r{</body>}i) { "#{tag}\n</body>" }
      set_length(headers, injected)
      [status, headers, [injected]]
    end

    private

    def inject?(status, headers)
      return false unless status.to_i == 200
      return false unless Deskcrew.config.widget_ready?

      type = header(headers, "Content-Type").to_s
      type.include?("text/html")
    end

    def header(headers, name)
      headers[name] || headers[name.downcase]
    end

    def set_length(headers, html)
      key = headers.key?("content-length") ? "content-length" : "Content-Length"
      headers[key] = html.bytesize.to_s if headers.key?("Content-Length") || headers.key?("content-length")
    end
  end
end
