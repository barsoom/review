defmodule AcceptanceTestHelpers do
  use Hound.Helpers

  def fill_in(field, with: value), do: find_element(:name, field) |> fill_field(value)

  def navigate_to_commits_page, do: navigate_to "/commits?auth_key=secret"

  def navigate_to_settings_page, do: navigate_to "/settings?auth_key=secret"
end
