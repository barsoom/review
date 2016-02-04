defmodule Exremit.CommitChannel do
  use Phoenix.Channel

  alias Exremit.Repo
  alias Exremit.Commit
  alias Exremit.CommitSerializer

  def join(_channel, _auth, socket) do
    {:ok, socket}
  end

  def handle_in("start_review", %{ "id" => id }, socket) do
    if Mix.env != :dev do
      raise "auth not done in user_socket yet, fix that before removing this line"
    end

    commit = Repo.get!(Exremit.Repo.commits, id)
    commit = %{commit | review_started_at: Ecto.DateTime.local}
    Repo.update(commit)

    broadcast! socket, "updated_commit", CommitSerializer.serialize(commit)

    {:noreply, socket}
  end
end
