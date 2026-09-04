# deskcrew-rails

![DeskCrew widget on every Rails page](https://deskcrew.io/packages/deskcrew-rails.gif)

**Live chat, an AI support chatbot and helpdesk ticketing for Ruby on Rails, in one gem.** deskcrew-rails adds the [DeskCrew](https://deskcrew.io) support widget to a Rails app: visitors chat with an AI that answers from your knowledge base, anything it cannot answer becomes a ticket, and a human approves every reply before it sends. It also gives you a tiny client so a contact form, a feedback form or a background job can open a ticket from Ruby.

Works with Rails 6.1 to 8, Hotwire, Turbo, Stimulus, Devise, importmap and Propshaft. Nothing to add to the asset pipeline. Free plan, no credit card: https://deskcrew.io/signup

## Use it for

- **Live chat on a Rails app** without writing JavaScript: one helper in the layout, or one config flag for every page.
- **An AI chatbot for customer support** that only answers from your own help articles, with a human handoff when it is unsure.
- **Contact form to support ticket**: post the form fields to `Deskcrew::Client.create_ticket` and the message lands in your inbox as a ticket.
- **A help center and knowledge base** for a SaaS, an e-commerce store, a Rails API with a marketing site, or an internal tool.
- **Replacing a paid chat widget** (Intercom, Crisp, Tawk.to, Zendesk, Freshdesk, HelpScout) with one that starts free and never sends a reply you did not approve.

## Install

```ruby
# Gemfile
gem "deskcrew-rails"
```

```bash
bundle install
bin/rails generate deskcrew:install
```

The generator writes `config/initializers/deskcrew.rb`:

```ruby
Deskcrew.configure do |config|
  config.widget_key = ENV.fetch("DESKCREW_WIDGET_KEY", nil) # "pub_..." from your dashboard's Install page
  config.board = ENV.fetch("DESKCREW_BOARD", nil)           # your board slug
  config.site_url = "https://www.example.com"               # this site's public origin
  # config.color = "#4f46e5"
  # config.position = "right"                               # or "left"
  # config.greeting = "Hi! How can we help?"
  # config.auto_inject = true                               # see below
  # config.enabled = !Rails.env.test?
end
```

## Show the widget

Either add the helper to your layout, just before `</body>`:

```erb
<%= deskcrew_widget_tag %>
```

or set `config.auto_inject = true` and a middleware adds the same tag to every successful HTML response. JSON, redirects, streams and error pages are left alone, and a page that already carries the tag is never given a second one.

## Allow your domain

The widget only runs on origins you have registered. Once per environment:

```bash
bin/rails deskcrew:register_origin
```

This sends your `site_url` to DeskCrew together with your public widget key. The same thing happens when you paste the key on the dashboard's Install page, so run it only if you configured the key here first.

## Create tickets from your code

```ruby
Deskcrew::Client.create_ticket(
  name: current_user.name,
  email: current_user.email,
  message: params[:message]
)
```

Returns `true` when DeskCrew accepted the ticket, `false` otherwise. It never raises into your request cycle, and the call takes at most ten seconds, so wrap it in a background job if you create tickets in bulk.

## FAQ

### How do I add live chat to a Ruby on Rails app?

Install this gem, run `bin/rails generate deskcrew:install`, put your widget key in the initializer, and add `<%= deskcrew_widget_tag %>` before `</body>` in `app/views/layouts/application.html.erb`. Every view that uses that layout gets the chat bubble. Set `config.auto_inject = true` instead if you would rather not touch layouts.

### Does the widget work with Hotwire and Turbo Drive?

Yes. The widget mounts once into its own container and Turbo replaces page bodies without touching it, so an open conversation survives navigation. Turbo Frames and Streams are unaffected.

### Do I need to add anything to the asset pipeline, importmap or Propshaft?

No. The widget is a single external script loaded from deskcrew.io, not an application asset. There is no Sprockets entry, no importmap pin and no bundling step.

### Can I create a support ticket from a Rails controller or a background job?

Yes. `Deskcrew::Client.create_ticket(name:, email:, message:)` posts the ticket and returns true or false. It never raises into your request cycle and times out after ten seconds, so call it from a job (Sidekiq, Solid Queue, GoodJob) when you create tickets in bulk.

### Is the AI chatbot going to make things up?

It answers only from the knowledge base you publish on DeskCrew and says so when it does not know. Anything it cannot answer becomes a ticket, and a person approves every outbound reply. The AI never emails a customer on its own.

### Does it work with Devise, multi-tenant apps or several layouts?

Devise: yes, the widget is independent of authentication; pass `current_user` details to `create_ticket` if you want tickets tied to accounts. Several layouts: add the helper to each layout you want covered, or use `auto_inject`. Multi-tenant apps with one DeskCrew board per tenant can call `deskcrew_widget_tag` with a different key per request.

### Is there a free plan?

Yes. The free plan includes the chat widget, ticketing, a public help center and a monthly AI answer allowance, with no credit card. Paid plans add inbound email, white-label and more AI answers: https://deskcrew.io/pricing

### Does it work with Sinatra, Hanami or a plain Rack app?

The Rack middleware (`Deskcrew::Middleware`) and `Deskcrew::Client` do not depend on Rails, so a Sinatra or Rack app can use them directly. The view helper, generator and rake task are Rails-only.

## What the gem sends to DeskCrew

- The widget script tag points at `https://deskcrew.io/desk.js` with your public widget key and the optional board, colour, position and greeting. Every value is validated and HTML-escaped before it reaches the page.
- `deskcrew:register_origin` posts your `site_url` and widget key to `https://deskcrew.io/api/widget/register-origin`.
- `Deskcrew::Client.create_ticket` posts the name, email and message to `https://deskcrew.io/api/widget/submit` with your `site_url` as the Origin.

Nothing else leaves your app. Terms: https://deskcrew.io/terms. Privacy: https://deskcrew.io/privacy.

## Requirements

Ruby 3.0 or newer. Rails 6.1, 7.0, 7.1, 7.2 or 8.0. Tested against Rack 2.2 and Rack 3.

## License

MIT. See LICENSE.txt.
