defmodule AcceptanceTestHelpers do
  use Hound.Helpers

  def fill_in(field, with: value), do: find_element(:name, field) |> fill_field(value)

  def navigate_to_commits_page, do: navigate_to_page "commits"

  def navigate_to_settings_page, do: navigate_to_page "settings"

  defp navigate_to_page(page_name) do
    navigate_to "/?auth_key=secret"
    find_element(:class, "test-menu-item-#{page_name}") |> click
  end
end
