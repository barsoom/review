defmodule Exremit.PageController do
  use Exremit.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", commits_data: commits_data, comments_data: comments_data
  end

  defp commits_data, do: Exremit.Repo.commits_data(25)
  defp comments_data, do: Exremit.Repo.comments_data(25)
end
