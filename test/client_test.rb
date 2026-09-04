# frozen_string_literal: true

require_relative "test_helper"

class ClientTest < Minitest::Test
  def test_register_origin_posts_key_and_origin
    configured
    http = FakeHttp.new
    assert Deskcrew::Client.register_origin(http: http)
    req = http.requests.first
    assert_equal "/api/widget/register-origin", req.path
    assert_equal({ "key" => "pub_abc123", "origin" => "https://www.example.com" }, JSON.parse(req.body))
    assert_equal "application/json", req["Content-Type"]
  end

  def test_register_origin_refuses_non_https_site_url
    configured(site_url: "http://localhost:3000")
    http = FakeHttp.new
    refute Deskcrew::Client.register_origin(http: http)
    assert_empty http.requests
  end

  def test_create_ticket_posts_the_submission_with_the_site_origin
    configured
    http = FakeHttp.new
    assert Deskcrew::Client.create_ticket(name: "Ada", email: "ada@example.com", message: "Help", http: http)
    req = http.requests.first
    assert_equal "/api/widget/submit", req.path
    assert_equal "https://www.example.com", req["Origin"]
    assert_equal "Ada", JSON.parse(req.body)["name"]
  end

  def test_create_ticket_needs_email_and_message
    configured
    http = FakeHttp.new
    refute Deskcrew::Client.create_ticket(email: "", message: "x", http: http)
    refute Deskcrew::Client.create_ticket(email: "a@b.c", message: "  ", http: http)
    assert_empty http.requests
  end

  def test_network_failure_returns_false_not_an_exception
    configured
    boom = Object.new
    def boom.request(_req) = raise(IOError, "down")
    refute Deskcrew::Client.create_ticket(email: "a@b.c", message: "x", http: boom)
  end

  def test_non_2xx_is_false
    configured
    refute Deskcrew::Client.register_origin(http: FakeHttp.new("403"))
  end
end
