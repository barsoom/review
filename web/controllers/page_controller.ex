defmodule Exremit.PageController do
  use Exremit.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def commits(conn, _params) do
    render conn, "commits.html", commits_json: commits_json
  end

  defp commits_json do
    Exremit.Repo.commits
    |> Exremit.Repo.all
    |> Exremit.CommitSerializer.serialize
    |> Poison.encode!
  end
end
