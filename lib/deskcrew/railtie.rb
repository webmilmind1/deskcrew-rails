# frozen_string_literal: true

require "rails/railtie"

module Deskcrew
  class Railtie < Rails::Railtie
    initializer "deskcrew.helper" do
      ActiveSupport.on_load(:action_view) { include Deskcrew::Helper }
    end

    initializer "deskcrew.middleware" do |app|
      app.middleware.use Deskcrew::Middleware if Deskcrew.config.auto_inject
    end

    rake_tasks do
      load File.expand_path("../tasks/deskcrew.rake", __dir__)
    end
  end
end
