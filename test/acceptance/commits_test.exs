defmodule Exremit.CommitsTest do
  use Exremit.AcceptanceCase
  import Exremit.Factory

  test "shows a list of commits, with the newest on top" do
    commit1 = create(:commit)
    commit2 = create(:commit)
    commit3 = create(:commit)

    navigate_to_commits_page

    elements = find_all_elements(:css, ".test-commit")
    assert length(elements) == 3

    commit_ids = elements
      |> Enum.map(fn e ->
        attribute_value(e, :id)
      end)

    assert commit_ids == [
      "commit-#{commit3.id}",
      "commit-#{commit2.id}",
      "commit-#{commit1.id}",
    ]
  end

  test "shows interesting info about commits" do
    commit1 = create(:commit, reviewed_at: nil)
    commit2 = create(:commit, reviewed_at: Ecto.DateTime.utc)

    navigate_to_commits_page

    status = read_status(commit1)
    assert status.summary =~ "This is a very"
    assert status.timestamp =~ "Mon 25 Jan"
    assert !status.is_reviewed

    status = read_status(commit2)
    assert status.is_reviewed
  end

  test "works for simultaneous visitors" do
    create(:commit, author: create(:author, name: "charles"))

    visitor "ada", fn ->
      navigate_to_settings_page
      fill_in "name", with: "ada"
      navigate_to_commits_page
      can_see_commit
    end

    visitor "charles", fn ->
      navigate_to_commits_page
      can_see_commit
    end

    visitor "ada", fn ->
      commit_looks_new
      click_button "Start review"
      commit_looks_pending
    end

    # NOTE: you need a new phantomjs for this, newer than 2, 2.1.1 is known to work.
    visitor "charles", fn ->
      commit_looks_pending
    end

    visitor "ada", fn ->
      commit_looks_pending
      click_button "Abandon review"
      commit_looks_new
      click_button "Start review"
      click_button "Mark as reviewed"
      commit_looks_reviewed
    end

    visitor "charles", fn ->
      commit_looks_reviewed
    end

    visitor "ada", fn ->
      click_button "Mark as new"
      commit_looks_new
    end

    visitor "charles", fn ->
      commit_looks_new
    end
  end

  test "shows which commits is authored by you" do
    navigate_to_settings_page
    fill_in "name", with: "Jo"

    commit1 = create(:commit, author: create(:author, name: "Charles And Joe"))
    commit2 = create(:commit, author: create(:author, name: "Jane And Bob"))

    navigate_to_commits_page

    assert authored_by_you(commit1)
    assert not authored_by_you(commit2)
  end

  defp authored_by_you(commit) do
    "test-authored-by-you" in commit_classes(find_element(:id, "commit-#{commit.id}"))
  end

  defp visitor(name, callback), do: in_browser_session name, callback

  defp can_see_commit, do: commit_element

  defp commit_looks_new do
    assert "test-is-new" in commit_classes
  end

  defp commit_looks_pending do
    assert "test-is-being-reviewed" in commit_classes
  end

  defp commit_looks_reviewed do
    assert "test-is-reviewed" in commit_classes
  end

  def button_classes do
    find_element(:css, ".test-button")
    |> attribute_value("class")
    |> String.split
  end

  def commit_classes(element \\ commit_element) do
    element
    |> attribute_value("class")
    |> String.split
  end

  defp click_button(name) do
    find_button(name) |> click
  end

  def find_button(name, attempt \\ 0) do
    find_all_elements(:css, ".test-button")
    |> Enum.find(fn (element) -> inner_text(element) == name end)
    |> retry_find_button(name, attempt)
  end

  defp retry_find_button(nil, name, 5), do: raise "Could not find any button named \"#{name}\""
  defp retry_find_button(nil, name, attempt) do
    :timer.sleep 10
    find_button(name, attempt + 1)
  end
  defp retry_find_button(element, _name, _attemp), do: element

  defp commit_element, do: find_element(:css, ".test-commit")

  defp read_status(commit) do
    element = find_element(:id, "commit-#{commit.id}")

    %{
      summary: find_within_element(element, :css, ".test-summary") |> inner_text,
      timestamp: find_within_element(element, :css, ".test-timestamp") |> inner_text,
      is_reviewed: element |> attribute_value("class") =~ ~r/test-is-reviewed/,
    }
  end
end
