defmodule Exremit.CommitSerializerTest do
  use ExUnit.Case
  import Exremit.Factory

  test "serializes a commit" do
    author = build(:author, email: "foo@example.com")
    commit = build(:commit, id: 50, author: author)

    data = Exremit.CommitSerializer.serialize(commit)

    # See the test/fixtures/payload.json for the source data
    assert data == %{
      id: 50,
      summary: "This is a very long message that will be shortened",
      gravatarHash: "b48def645758b95537d4424c84d1a9ff",
    }
  end
end
