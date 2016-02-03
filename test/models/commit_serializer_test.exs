defmodule Exremit.CommitSerializerTest do
  use ExUnit.Case
  import Exremit.Factory

  test "serializes a commit" do
    commit = build(:commit, id: 50)

    data = Exremit.CommitSerializer.serialize(commit)

    # See the test/fixtures/payload.json for the source data
    assert data == %{
      id: 50,
      summary: "This is a very long message that will be shortened",
    }
  end
end
