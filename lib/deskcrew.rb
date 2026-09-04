# frozen_string_literal: true

require "deskcrew/version"
require "deskcrew/configuration"
require "deskcrew/widget"
require "deskcrew/helper"
require "deskcrew/middleware"
require "deskcrew/client"
require "deskcrew/railtie" if defined?(Rails::Railtie)

module Deskcrew
  class << self
    def config
      @config ||= Configuration.new
    end

    def configure
      yield config
      config
    end

    def reset!
      @config = Configuration.new
    end
  end
end
