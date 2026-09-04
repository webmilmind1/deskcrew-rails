# frozen_string_literal: true

require "rails/generators"

module Deskcrew
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)
      desc "Writes config/initializers/deskcrew.rb"

      def create_initializer
        template "deskcrew.rb.tt", "config/initializers/deskcrew.rb"
      end

      def show_next_steps
        say ""
        say "DeskCrew installed. Next:", :green
        say "  1. Put your widget key in config/initializers/deskcrew.rb (or DESKCREW_WIDGET_KEY)."
        say "  2. Add <%= deskcrew_widget_tag %> before </body> in your layout, or set auto_inject = true."
        say "  3. Run bin/rails deskcrew:register_origin once per environment."
      end
    end
  end
end
