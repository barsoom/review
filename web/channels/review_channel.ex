defmodule Review.ReviewChannel do
  use Phoenix.Channel

  alias Review.{Repo, CommitSerializer, CommentSerializer}

  def join(_channel, _auth, socket) do
    send self(), :after_join
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "welcome", %{ commits: commits_data(), comments: comments_data() }

    {:noreply, socket}
  end

  def handle_in("StartReview", %{ "id" => id, "byEmail" => email }, socket) do
    reviewer = Review.Repo.insert_or_update_author(%{ email: email })

    update_commit_and_broadcast_changes(id,
      %{ review_started_at: Ecto.DateTime.utc,
         review_started_by_author_id: reviewer.id }, socket)
  end

  def handle_in("AbandonReview", %{ "id" => id }, socket) do
    update_commit_and_broadcast_changes(id,
      %{ review_started_at: nil,
         review_started_by_author_id: nil }, socket)
  end

  def handle_in("MarkAsReviewed", %{ "id" => id, "byEmail" => email }, socket) do
    reviewer = Review.Repo.insert_or_update_author(%{ email: email })

    update_commit_and_broadcast_changes(id,
      %{ reviewed_at: Ecto.DateTime.utc,
         review_started_by_author_id: nil,
         reviewed_by_author_id: reviewer.id }, socket)
  end

  def handle_in("MarkAsNew", %{ "id" => id }, socket) do
    update_commit_and_broadcast_changes(id,
      %{ reviewed_at: nil,
         review_started_at: nil,
         review_started_by_author_id: nil }, socket)
  end

  def handle_in("MarkCommentAsResolved", %{ "id" => id, "byEmail" => email }, socket) do
    resolver = Review.Repo.insert_or_update_author(%{ email: email })

    update_comment_and_broadcast_changes(id,
      %{ resolved_at: Ecto.DateTime.utc,
         resolved_by_author_id: resolver.id }, socket)
  end

  def handle_in("MarkCommentAsNew", %{ "id" => id, "byEmail" => _email }, socket) do
    update_comment_and_broadcast_changes(id,
      %{ resolved_at: nil,
         resolved_by_author_id: nil }, socket)
  end

  defp update_commit_and_broadcast_changes(id, changes, socket) do
    Repo.get!(Review.Repo.commits, id)
    |> Ecto.Changeset.change(changes)
    |> Repo.update!

    commit = Repo.get!(Review.Repo.commits, id)

    broadcast! socket, "new_or_updated_commit", CommitSerializer.serialize(commit)

    {:noreply, socket}
  end

  defp update_comment_and_broadcast_changes(id, changes, socket) do
    Repo.get!(Review.Repo.comments, id)
    |> Ecto.Changeset.change(changes)
    |> Repo.update!

    comment = Repo.get!(Review.Repo.comments, id)

    broadcast! socket, "new_or_updated_comment", CommentSerializer.serialize(comment)

    {:noreply, socket}
  end

  # The number of records to show (on load and after updates), for speed.
  # Gets slower with more records.
  @max_records Application.get_env(:review, :max_records)

  defp commits_data, do: Review.Repo.commits_data(@max_records)
  defp comments_data, do: Review.Repo.comments_data(@max_records)
end
