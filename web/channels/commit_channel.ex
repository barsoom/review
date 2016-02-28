defmodule Exremit.CommitChannel do
  use Phoenix.Channel

  alias Exremit.Repo
  alias Exremit.Commit
  alias Exremit.CommitSerializer

  def join(_channel, _auth, socket) do
    {:ok, socket}
  end

  def handle_in("StartReview", %{ "id" => id, "byEmail" => email }, socket) do
    IO.inspect email: email
    update_commit_and_broadcast_changes(id, %{ review_started_at: Ecto.DateTime.utc }, socket)
  end

  def handle_in("AbandonReview", %{ "id" => id }, socket) do
    update_commit_and_broadcast_changes(id, %{ review_started_at: nil }, socket)
  end

  def handle_in("MarkAsReviewed", %{ "id" => id }, socket) do
    update_commit_and_broadcast_changes(id, %{ reviewed_at: Ecto.DateTime.utc }, socket)
  end

  def handle_in("MarkAsNew", %{ "id" => id }, socket) do
    update_commit_and_broadcast_changes(id, %{ reviewed_at: nil, review_started_at: nil }, socket)
  end

  defp update_commit_and_broadcast_changes(id, changes, socket) do
    commit =
      Repo.get!(Exremit.Repo.commits, id)
      |> Ecto.Changeset.change(changes)
      |> Repo.update!

    broadcast! socket, "updated_commit", CommitSerializer.serialize(commit)

    {:noreply, socket}
  end
end
