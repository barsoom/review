defmodule Review.CommentsTest do
  use Review.AcceptanceCase
  import Review.Factory

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

  test "comments can be filtered" do
    carl = insert(:author, name: "Carl Carlsson")
    jane = insert(:author, name: "Jane Smith")
    fred = insert(:author, name: "Fred Flintstone")

    your_comment = insert(:comment, author: carl)
    resolved_comment = insert(:comment, resolved_by_author: jane)

    insert(:commit, sha: "a", author: fred)
    other_people_comment_on_other_peoples_commit = insert(:comment, author: jane, commit_sha: "a", json_payload: payload_that_has_different_thread_identifier)

    insert(:commit, sha: "b", author: carl)
    unresolved_comment_on_your_commit = insert(:comment, commit_sha: "b")

    insert(:commit, sha: "c", author: fred)
    _your_comment = insert(:comment, author: carl, commit_sha: "c")
    comment_on_your_comment = insert(:comment, author: jane, commit_sha: "c")

    navigate_to_settings_page
    fill_in "name", with: "Carl"

    navigate_to_comments_page
    assert visible?(your_comment)
    assert visible?(resolved_comment)
    assert visible?(other_people_comment_on_other_peoples_commit)
    assert visible?(unresolved_comment_on_your_commit)
    assert visible?(comment_on_your_comment)

    uncheck "test-comments-i-wrote"

    assert !visible?(your_comment)
    assert visible?(resolved_comment)
    assert visible?(other_people_comment_on_other_peoples_commit)
    assert visible?(unresolved_comment_on_your_commit)
    assert visible?(comment_on_your_comment)

    uncheck "test-resolved-comments"

    assert !visible?(your_comment)
    assert !visible?(resolved_comment)
    assert visible?(other_people_comment_on_other_peoples_commit)
    assert visible?(unresolved_comment_on_your_commit)
    assert visible?(comment_on_your_comment)

    uncheck "test-comments-on-others"

    assert !visible?(your_comment)
    assert !visible?(resolved_comment)
    assert !visible?(other_people_comment_on_other_peoples_commit)
    assert visible?(unresolved_comment_on_your_commit)
    assert visible?(comment_on_your_comment)

    # TODO: test persistence of settings
  end

  defp payload_that_has_different_thread_identifier do
    Review.Factory.comment_payload |> String.replace("2be8", "aaaa")
  end

  defp uncheck(checkbox_class) do
    checkbox = find_element(:css, ".#{checkbox_class}")
    assert selected?(checkbox)
    click(checkbox)
    assert !selected?(checkbox)
  end

  defp visible?(comment) do
    find_all_elements(:id, "comment-#{comment.id}") != []
  end
end
