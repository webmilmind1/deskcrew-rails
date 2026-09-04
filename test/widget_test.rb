# frozen_string_literal: true

require_relative "test_helper"

class WidgetTest < Minitest::Test
  def test_tag_carries_key_board_and_defer
    configured
    tag = Deskcrew::Widget.tag
    assert_includes tag, 'src="https://deskcrew.io/desk.js"'
    assert_includes tag, 'data-key="pub_abc123"'
    assert_includes tag, 'data-board="acme"'
    assert_includes tag, 'data-position="right"'
    assert_match(/ defer><\/script>\z/, tag)
  end

  def test_empty_without_a_valid_key_or_when_disabled
    configured(widget_key: "pub_bad key!")
    assert_equal "", Deskcrew::Widget.tag
    configured(enabled: false)
    assert_equal "", Deskcrew::Widget.tag
  end

  def test_bad_optional_values_are_dropped_not_passed_through
    configured(board: "Not A Slug", color: "red", position: "middle")
    tag = Deskcrew::Widget.tag
    refute_includes tag, "data-board"
    refute_includes tag, "data-color"
    refute_includes tag, "data-position"
  end

  def test_greeting_is_escaped_and_truncated
    configured(greeting: '"><img src=x>' + ("a" * 200))
    tag = Deskcrew::Widget.tag
    refute_includes tag, "<img"
    assert_includes tag, "&quot;&gt;&lt;img src=x&gt;"
    assert_operator tag.length, :<, 400
  end

  def test_helper_returns_html_safe_string_when_available
    configured
    view = Object.new.extend(Deskcrew::Helper)
    assert_includes view.deskcrew_widget_tag, "desk.js"
  end
end
