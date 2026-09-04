# frozen_string_literal: true

module Deskcrew
  # View helper. In your layout, just before </body>:
  #   <%= deskcrew_widget_tag %>
  module Helper
    def deskcrew_widget_tag
      html = Deskcrew::Widget.tag
      html.respond_to?(:html_safe) ? html.html_safe : html # rubocop:disable Rails/OutputSafety
    end
  end
end
