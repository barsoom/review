defmodule AcceptanceTestHelpers do
  use Hound.Helpers

  def fill_in(field, with: value), do: find_element(:name, field) |> fill_field(value)

  def click_button(name) do
    find_button(name) |> click
  end

  def visitor(name, callback), do: in_browser_session name, callback

  def navigate_to_commits_page, do: navigate_to_page "commits"

  def navigate_to_settings_page, do: navigate_to_page "settings"

  def navigate_to_comments_page, do: navigate_to_page "comments"

  defp navigate_to_page(page_name) do
    navigate_to "/#{page_name}?auth_key=secret"
  end

  defp find_button(name, attempt \\ 0) do
    find_all_elements(:css, ".test-button")
    |> Enum.find(fn (element) -> String.trim(inner_text(element)) == name end)
    |> retry_find_button(name, attempt)
  end

  defp retry_find_button(nil, name, 5), do: raise "Could not find any button named \"#{name}\""
  defp retry_find_button(nil, name, attempt) do
    :timer.sleep 10
    find_button(name, attempt + 1)
  end
  defp retry_find_button(element, _name, _attemp), do: element
end
