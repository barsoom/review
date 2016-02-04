defmodule Exremit.CommitsTest do
  use Exremit.AcceptanceCase
  import Exremit.Factory

  test "shows a list of commits, with the newest on top" do
    commit1 = create(:commit)
    commit2 = create(:commit)
    commit3 = create(:commit)

    navigate_to "/commits?auth_key=secret"

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

    navigate_to "/commits?auth_key=secret"

    status = read_status(commit1)
    assert status.summary =~ "This is a very"
    assert status.timestamp =~ "Mon 25 Jan at 08:41"
    assert !status.is_reviewed

    status = read_status(commit2)
    assert status.is_reviewed
  end

  defp read_status(commit) do
    element = find_element(:id, "commit-#{commit.id}")

    %{
      summary: find_within_element(element, :css, ".test-summary") |> inner_text,
      timestamp: find_within_element(element, :css, ".test-timestamp") |> inner_text,
      is_reviewed: element |> attribute_value("class") =~ ~r/test-is-reviewed/,
    }
  end
end
