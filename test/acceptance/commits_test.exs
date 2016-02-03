defmodule Exremit.CommitsTest do
  use Exremit.AcceptanceCase
  import Exremit.Factory

  test "shows a list of commits" do
    create(:commit, %{ sha: "2107c5d7b290c0ca294d4d70029e87b599bc9152" })

    navigate_to "/commits"

    elements = find_all_elements(:css, ".test-commit")
    IO.inspect wip_test: length(elements)
    assert true
    #assert length(elements) == 3
  end
end
