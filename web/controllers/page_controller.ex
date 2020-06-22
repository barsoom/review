defmodule Review.PageController do
  use Review.Web, :controller

  def index(_conn, %{ "page" => "boom" }) do
    raise "this is an error made to test the error reporter"
  end

  def index(conn, _params) do
    redirect_to_url = System.get_env("REDIRECT_TO_URL")

    if redirect_to_url do
      redirect conn, external: redirect_to_url
    else
      render conn, "index.html", commits_data: commits_data(), comments_data: comments_data()
    end
  end

  defp commits_data, do: Review.Repo.commits_data(25)
  defp comments_data, do: Review.Repo.comments_data(25)
end
