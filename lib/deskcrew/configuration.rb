# frozen_string_literal: true

module Deskcrew
  # Everything the widget and the client need. Set it once in
  # config/initializers/deskcrew.rb (rails g deskcrew:install writes one).
  class Configuration
    # Public widget key from your DeskCrew dashboard (Install page). Starts with "pub_".
    attr_accessor :widget_key
    # Your board slug, e.g. "acme" for deskcrew.io/board/acme.
    attr_accessor :board
    # Widget accent colour as a hex string, e.g. "#4f46e5".
    attr_accessor :color
    # "right" (default) or "left".
    attr_accessor :position
    # First line the widget shows, up to 120 characters.
    attr_accessor :greeting
    # Your site's public origin, e.g. "https://www.example.com". Used to register the
    # widget for your domain and as the Origin of tickets created by the client.
    attr_accessor :site_url
    # Set false to keep the widget off without removing the gem.
    attr_accessor :enabled
    # When true, a middleware injects the widget before </body> on HTML responses.
    # Leave false and call deskcrew_widget_tag in your layout instead.
    attr_accessor :auto_inject
    # Where DeskCrew lives. Only change this if DeskCrew tells you to.
    attr_accessor :app_url

    KEY_FORMAT = /\Apub_[A-Za-z0-9]+\z/
    BOARD_FORMAT = /\A[a-z0-9-]+\z/
    COLOR_FORMAT = /\A#[0-9a-fA-F]{6}\z/
    GREETING_MAX = 120

    def initialize
      @widget_key = ENV.fetch("DESKCREW_WIDGET_KEY", nil)
      @board = ENV.fetch("DESKCREW_BOARD", nil)
      @color = nil
      @position = "right"
      @greeting = nil
      @site_url = nil
      @enabled = true
      @auto_inject = false
      @app_url = "https://deskcrew.io"
    end

    # True when there is a usable key and the widget is switched on.
    def widget_ready?
      enabled && KEY_FORMAT.match?(widget_key.to_s)
    end

    # Values the way the widget accepts them; bad input is dropped, never passed through.
    def sanitized
      {
        key: (KEY_FORMAT.match?(widget_key.to_s) ? widget_key : nil),
        board: (BOARD_FORMAT.match?(board.to_s) ? board : nil),
        color: (COLOR_FORMAT.match?(color.to_s) ? color : nil),
        position: (%w[left right].include?(position.to_s) ? position.to_s : nil),
        greeting: (greeting.to_s.empty? ? nil : greeting.to_s[0, GREETING_MAX])
      }
    end
  end
end
