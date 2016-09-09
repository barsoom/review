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
      commitAuthorName: "Joe",
      body: "Since this is an open source lib, how about we doc this in README?",
    }
  end
end
