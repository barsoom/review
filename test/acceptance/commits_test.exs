defmodule Exremit.CommitsTest do
  use Exremit.AcceptanceCase
  import Exremit.Factory

  test "shows a list of commits" do
    create(:commit, %{ sha: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" })
    create(:commit, %{ sha: "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb" })
    create(:commit, %{ sha: "cccccccccccccccccccccccccccccccccccccccc" })

    navigate_to "/commits"

    elements = find_all_elements(:css, ".test-commit")
    IO.inspect wip_test: length(elements)

    :timer.sleep 500
    assert page_source() =~ ~r/Hello from ELM/
    #assert length(elements) == 3
  end
end
