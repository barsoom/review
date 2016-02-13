defmodule Exremit.PageController do
  use Exremit.Web, :controller

  # The number of records to show (on load and after updates), for speed.
  # Gets slower with more records.
  @max_records Application.get_env(:exremit, :max_records)

  def index(conn, _params) do
    render conn, "index.html"
  end

  def commits(conn, _params) do
    render conn, "commits.html", commits_data: commits_data
  end

  defp commits_data do
    Exremit.Repo.commits
    |> Ecto.Query.limit(@max_records)
    |> Exremit.Repo.all
    |> Exremit.CommitSerializer.serialize
  end
end
