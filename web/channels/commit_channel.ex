defmodule Exremit.CommitChannel do
  use Phoenix.Channel

  import Ecto.Query

  alias Exremit.Repo
  alias Exremit.Commit
  alias Exremit.CommitSerializer

  def join(_channel, _auth, socket) do
    send self, :after_join
    {:ok, _} = :timer.send_interval(1 * 1000, :send_ping)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "welcome", %{ commits: commits_data, comments: comments_data, revision: System.get_env("HEROKU_SLUG_COMMIT") }

    {:noreply, socket}
  end

  def handle_info(:send_ping, socket) do
    push socket, "ping", %{}
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
    commit =
      Repo.get!(Exremit.Repo.commits, id)
      |> Ecto.Changeset.change(changes)
      |> Repo.update!

    commit = Repo.get!(Exremit.Repo.commits, id)

    broadcast! socket, "updated_commit", CommitSerializer.serialize(commit)

    {:noreply, socket}
  end

  # The number of records to show (on load and after updates), for speed.
  # Gets slower with more records.
  @max_records Application.get_env(:exremit, :max_records)

  defp commits_data, do: Exremit.Repo.commits_data(@max_records)
  defp comments_data, do: Exremit.Repo.comments_data(@max_records)
end
