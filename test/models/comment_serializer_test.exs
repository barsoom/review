defmodule Review.CommentSerializerTest do
  use ExUnit.Case
  import Review.Factory

  test "serializes a comment" do
    author = build(:author, name: "Joe")
    commit = build(:commit, author: author)
    resolver = build(:author, name: "Foo", email: "foo@example.com")
    comment = build(:comment, id: 50, commit: commit, resolved_by_author: resolver)

    data = Review.CommentSerializer.serialize(comment)

    assert data == %{
      id: 50,
      timestamp: "2016-09-05T13:31:37Z",
      authorName: "Joe",
      authorGravatar: "f5b8fb60c6116331da07c65b96a8a1d1",
      commitAuthorGravatar: "f5b8fb60c6116331da07c65b96a8a1d1",
      commitAuthorName: "Joe",
      commitSummary: "This is a very long message that will be shortened",
      body: "Since this is an open source lib, how about we doc this in README?",
      resolved: true,
      resolverGravatar: "b48def645758b95537d4424c84d1a9ff",
      resolverEmail: "foo@example.com",
      threadIdentifier: "2be829b9163897e8bb57ceea9709a5d5e61faee1:4:5",
      url: "https://github.com/barsoom/gridlook/commit/2be829b9163897e8bb57ceea9709a5d5e61faee1#commitcomment-18900296",
    }
  end
end
