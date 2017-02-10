defmodule Review.CommitSerializerTest do
  use ExUnit.Case
  import Review.Factory

  test "serializes a commit" do
    author = build(:author, email: "foo@example.com", name: "Joe")
    reviewer = build(:author, email: "bar@example.com", name: "Jane")
    commit = build(:commit, id: 50, author: author, review_started_by_author: reviewer, review_started_at: Ecto.DateTime.from_erl({{2011, 1, 1}, {0, 0, 0}}), reviewed_by_author: nil)

    data = Review.CommitSerializer.serialize(commit)

    # See the test/fixtures/payload.json for the source data
    assert data == %{
      id: 50,
      summary: "This is a very long message that will be shortened",
      authorGravatarHash: "b48def645758b95537d4424c84d1a9ff",
      pendingReviewerGravatarHash: "e8da7df89c8bcbfec59336b4e0d5e76d",
      reviewerGravatarHash: "81a354d1cf8aee4e4fc56cf78d98de00",
      pendingReviewerEmail: "bar@example.com",
      reviewerEmail: nil,
      repository: "gridlook",
      authorName: "Joe",
      timestamp: "2016-01-25T08:41:25+01:00",
      reviewStartedTimestamp: "2011-01-01T00:00:00",
      isNew: false,
      isReviewed: false,
      isBeingReviewed: true,
      url: "https://github.com/barsoom/gridlook/commit/c5472c5276f564621afe4b56b14f50e7c298dff9",
    }
  end
end
