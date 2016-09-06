defmodule Exremit.CommentsTest do
  use Exremit.AcceptanceCase
  import Exremit.Factory

  test "shows a list of comments, with the newest on top" do
    comment1 = insert(:comment)
    comment2 = insert(:comment)
    comment3 = insert(:comment)

    navigate_to_comments_page

    elements = find_all_elements(:css, ".test-comment")
    assert length(elements) == 3

    comment_ids = elements
      |> Enum.map(fn e ->
        attribute_value(e, :id)
      end)

    assert comment_ids == [
      "comment-#{comment3.id}",
      "comment-#{comment2.id}",
      "comment-#{comment1.id}",
    ]
  end
end
