defmodule Exremit.CommitsTest do
  use Exremit.AcceptanceCase

  test "testing the js-testing setup" do
    navigate_to "/"
    element = find_element(:css, ".jumbotron > a")
    click(element)
    element = find_element(:id, "js-run")
    assert inner_text(element) == "test-output"
  end
end
