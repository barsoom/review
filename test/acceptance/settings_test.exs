defmodule Review.SettingsTest do
  use Review.AcceptanceCase

  test "can save settings on the client" do
    navigate_to_settings_page

    # Default usage explaination
    assert usage_explaination == "If your name is \"Charles Babbage\", a commit authored e.g. by \"Charles Babbage\" or by \"Ada Lovelace and Charles Babbage\" will be considered yours."

    # Fill in details
    fill_in "email", with: "joe@example.com"
    fill_in "name", with: "Joe"

    # Your details are used in an example
    :timer.sleep 50
    assert usage_explaination == "A commit authored e.g. by \"Joe\" or by \"Ada Lovelace and Joe\" will be considered yours."

    # Is still around when the page reloads
    navigate_to_settings_page
    assert usage_explaination == "A commit authored e.g. by \"Joe\" or by \"Ada Lovelace and Joe\" will be considered yours."
  end

  defp usage_explaination, do: find_element(:css, ".test-usage-explanation") |> inner_text
end
