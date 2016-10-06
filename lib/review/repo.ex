defmodule Review.Repo do
  use Ecto.Repo, otp_app: :review
  import Ecto.Query

  alias Review.{Commit, Comment, AuthorQuery, StoreCommitComment, StorePush}

  def insert_or_update_author(params), do: AuthorQuery.insert_or_update_author(params)

  def store_commit_comment(comment_json), do: StoreCommitComment.call(comment_json)

  def store_push(push_json), do: StorePush.call(push_json)

  def commits_data(limit) do
    commits
    |> Ecto.Query.limit(^limit)
    |> all
    |> Review.CommitSerializer.serialize
  end

  def comments_data(limit) do
    comments
    |> Ecto.Query.limit(^limit)
    |> all
    |> Review.CommentSerializer.serialize
  end

  def commits do
    from _ in Commit,
      order_by: [ desc: :id ],
      preload:  [ :author, :reviewed_by_author, :review_started_by_author ]
  end

  def comments do
    from _ in Comment,
      order_by: [ desc: :id ],
      preload:  [ [ commit: :author ], :author, :resolved_by_author ]
  end
end
