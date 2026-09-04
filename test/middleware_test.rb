# frozen_string_literal: true

require_relative "test_helper"

class MiddlewareTest < Minitest::Test
  def app_for(status, type, body)
    inner = ->(_env) { [status, { "Content-Type" => type, "Content-Length" => body.bytesize.to_s }, [body]] }
    Deskcrew::Middleware.new(inner)
  end

  def call(mw)
    mw.call(Rack::MockRequest.env_for("/"))
  end

  def test_injects_before_body_on_html_200
    configured(auto_inject: true)
    status, headers, body = call(app_for(200, "text/html; charset=utf-8", "<html><body><p>hi</p></body></html>"))
    html = body.join
    assert_equal 200, status
    assert_match(%r{desk\.js.*</body>}m, html)
    assert_equal html.bytesize.to_s, headers["Content-Length"]
  end

  def test_leaves_json_redirects_and_errors_alone
    configured(auto_inject: true)
    [[200, "application/json", '{"a":1}'], [302, "text/html", "<html><body></body></html>"], [500, "text/html", "<html><body></body></html>"]].each do |status, type, body|
      _s, _h, out = call(app_for(status, type, body))
      refute_includes out.join, "desk.js"
    end
  end

  def test_does_not_double_inject
    configured(auto_inject: true)
    once = "<html><body>#{Deskcrew::Widget.tag}</body></html>"
    _s, _h, out = call(app_for(200, "text/html", once))
    assert_equal 1, out.join.scan("desk.js").length
  end

  def test_no_key_means_untouched_response
    configured(widget_key: nil, auto_inject: true)
    _s, _h, out = call(app_for(200, "text/html", "<html><body></body></html>"))
    refute_includes out.join, "desk.js"
  end
end
