defmodule Review.GithubController do
  use Review.Web, :webhook

  def create(conn, params) do
    handle_event conn, event_name(conn), params
  end

  defp handle_event(conn, "ping", _params) do
    conn |> text("pong")
  end

  defp event_name(conn) do
    conn.req_headers
      |> Enum.into(%{})
      |> Map.fetch!("x-github-event")
  end
end
