# frozen_string_literal: true

require_relative "lib/deskcrew/version"

Gem::Specification.new do |spec|
  spec.name        = "deskcrew-rails"
  spec.version     = Deskcrew::VERSION
  spec.authors     = ["DeskCrew"]
  spec.email       = ["support@deskcrew.io"]
  spec.summary     = "Live chat, AI support chatbot and helpdesk ticketing for Ruby on Rails apps (DeskCrew widget, " \
                     "Hotwire and Turbo safe, free plan)."
  spec.description = "Add customer support to a Rails app in one step: live chat widget, AI chatbot that answers " \
                     "from your knowledge base, a public help center, and support tickets with human-approved " \
                     "replies. The gem injects the DeskCrew widget through a view helper or an opt-in Rack " \
                     "middleware (works with Hotwire, Turbo, Stimulus, Devise, importmap and Propshaft, no asset " \
                     "pipeline entry), registers your domain, and ships a small client that turns contact forms, " \
                     "feedback forms and background jobs into tickets. Free plan, no credit card. An alternative " \
                     "to Intercom, Crisp, Tawk.to, Zendesk or Freshdesk widgets for Rails, Sinatra and Rack apps."
  spec.homepage    = "https://deskcrew.io/integrations/rails"
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.metadata = {
    "homepage_uri" => "https://deskcrew.io/integrations/rails",
    "documentation_uri" => "https://deskcrew.io/board/deskcrew/kb",
    "source_code_uri" => "https://github.com/webmilmind1/deskcrew-rails",
    "changelog_uri" => "https://github.com/webmilmind1/deskcrew-rails/blob/main/CHANGELOG.md",
    "bug_tracker_uri" => "https://github.com/webmilmind1/deskcrew-rails/issues",
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir["lib/**/*.rb", "lib/**/*.tt", "lib/**/*.rake", "README.md", "CHANGELOG.md", "LICENSE.txt"]
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 6.1"
  spec.add_dependency "rack", ">= 2.2"
end
