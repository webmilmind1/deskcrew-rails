# frozen_string_literal: true

namespace :deskcrew do
  desc "Register this site's origin with DeskCrew so the widget is allowed on your domain"
  task register_origin: :environment do
    config = Deskcrew.config
    abort "DeskCrew: set config.widget_key and config.site_url (https://...) first" unless config.widget_ready? && config.site_url.to_s.start_with?("https://")
    if Deskcrew::Client.register_origin
      puts "DeskCrew: #{config.site_url} registered for widget key #{config.widget_key[0, 8]}…"
    else
      abort "DeskCrew: registration failed; check the key on your dashboard's Install page"
    end
  end
end
