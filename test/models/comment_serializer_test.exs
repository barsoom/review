defmodule Exremit.CommentSerializerTest do
  use ExUnit.Case
  import Exremit.Factory

  test "serializes a comment" do
    comment = build(:comment, id: 50)

    data = Exremit.CommentSerializer.serialize(comment)

    assert data == %{
      id: 50,
      timestamp: "2016-09-05T13:31:37Z"
    }
  end
end
