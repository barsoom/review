defmodule Review.ReviewChannel do
  use Phoenix.Channel

  alias Review.{Repo, CommitSerializer}

  def join(_channel, _auth, socket) do
    send self, :after_join
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "welcome", %{ commits: commits_data, comments: comments_data }

    {:noreply, socket}
  end

  def handle_in("StartReview", %{ "id" => id, "byEmail" => email }, socket) do
    reviewer = Repo.find_or_insert_author_by_email(email)

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
    reviewer = Repo.find_or_insert_author_by_email(email)

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

  defp update_commit_and_broadcast_changes(id, changes, socket) do
    Repo.get!(Review.Repo.commits, id)
    |> Ecto.Changeset.change(changes)
    |> Repo.update!

    commit = Repo.get!(Review.Repo.commits, id)

    broadcast! socket, "updated_commit", CommitSerializer.serialize(commit)

    {:noreply, socket}
  end

  # The number of records to show (on load and after updates), for speed.
  # Gets slower with more records.
  @max_records Application.get_env(:review, :max_records)

  defp commits_data, do: Review.Repo.commits_data(@max_records)
  defp comments_data, do: Review.Repo.comments_data(@max_records)
end
