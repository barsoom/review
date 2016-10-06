defmodule Review.GithubController do
  use Review.Web, :webhook

  def create(conn, params) do
    handle_event conn, event_name(conn), params
  end

  defp handle_event(conn, "ping", _params) do
    conn |> text("pong")
  end

  defp handle_event(conn, "push", _params) do
    conn |> text("not-yet-implemented")
  end

  defp handle_event(conn, "commit_comment", %{ "comment" => comment_data_with_string_keys }) do
    Poison.encode!(comment_data_with_string_keys)
    |> Review.Repo.store_commit_comment
    |> broadcast_new_or_updated_comment

    conn |> text("ok")
  end

  defp event_name(conn) do
    conn.req_headers
    |> Enum.into(%{})
    |> Map.fetch!("x-github-event")
  end

  defp broadcast_new_or_updated_comment(comment) do
    Review.Endpoint.broadcast! "review", "new_or_updated_comment", Review.CommentSerializer.serialize(comment)
  end
end
