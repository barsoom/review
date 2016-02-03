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
    create(:commit)

    navigate_to "/commits?auth_key=secret"

    element = find_element(:css, ".test-commit")
    summary = find_within_element(element, :css, ".test-summary") |> inner_text

    assert summary =~ "This is a very"
  end
end
