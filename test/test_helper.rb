# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "minitest/autorun"
require "rack"
require "deskcrew"

# A stand-in for Net::HTTP that records the request and answers with a fixed code.
class FakeHttp
  attr_reader :requests

  def initialize(code = "200")
    @code = code
    @requests = []
  end

  def request(req)
    @requests << req
    Struct.new(:code).new(@code)
  end
end

def configured(**over)
  Deskcrew.reset!
  Deskcrew.configure do |c|
    c.widget_key = "pub_abc123"
    c.board = "acme"
    c.site_url = "https://www.example.com"
    over.each { |k, v| c.public_send("#{k}=", v) }
  end
end
