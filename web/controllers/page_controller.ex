defmodule Exremit.PageController do
  use Exremit.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def commits(conn, _params) do
    render conn, "commits.html"
  end
end
