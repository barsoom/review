defmodule Exremit.CommentSerializerTest do
  use ExUnit.Case
  import Exremit.Factory

  test "serializes a comment" do
    author = build(:author, name: "Joe")
    commit = build(:commit, author: author)
    comment = build(:comment, id: 50, commit: commit)

    data = Exremit.CommentSerializer.serialize(comment)

    assert data == %{
      id: 50,
      timestamp: "2016-09-05T13:31:37Z",
      authorGravatar: "f5b8fb60c6116331da07c65b96a8a1d1",
      commitAuthorGravatar: "f5b8fb60c6116331da07c65b96a8a1d1",
      commitAuthorName: "Joe",
      commitSummary: "This is a very long message that will be shortened",
      body: "Since this is an open source lib, how about we doc this in README?",
    }
  end
end
