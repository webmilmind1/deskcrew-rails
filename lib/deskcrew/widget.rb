# frozen_string_literal: true

require "erb"

module Deskcrew
  # Builds the one script tag the widget needs. Every attribute value is HTML-escaped
  # and only known-good values make it into the tag (see Configuration#sanitized).
  module Widget
    module_function

    def tag(config = Deskcrew.config)
      return "" unless config.widget_ready?

      values = config.sanitized
      attrs = { "src" => "#{config.app_url}/desk.js", "data-key" => values[:key] }
      attrs["data-board"] = values[:board] if values[:board]
      attrs["data-color"] = values[:color] if values[:color]
      attrs["data-position"] = values[:position] if values[:position]
      attrs["data-greeting"] = values[:greeting] if values[:greeting]

      pairs = attrs.map { |k, v| %(#{k}="#{ERB::Util.html_escape(v)}") }
      "<script #{pairs.join(' ')} defer></script>"
    end
  end
end
