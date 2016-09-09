defmodule Exremit.CommentSerializerTest do
  use ExUnit.Case
  import Exremit.Factory

  test "serializes a comment" do
    author = build(:author, name: "Joe")
    comment = build(:comment, id: 50, author: author)

    data = Exremit.CommentSerializer.serialize(comment)

    assert data == %{
      id: 50,
      timestamp: "2016-09-05T13:31:37Z",
      authorName: "Joe",
    }
  end
end
