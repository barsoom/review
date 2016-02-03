defmodule Exremit.CommitsTest do
  use Exremit.AcceptanceCase
  import Exremit.Factory

  test "shows a list of commits, with the newest on top" do
    commit1 = create(:commit, %{ sha: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" })
    commit2 = create(:commit, %{ sha: "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb" })
    commit3 = create(:commit, %{ sha: "cccccccccccccccccccccccccccccccccccccccc" })

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
end
