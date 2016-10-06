defmodule Review.GithubController do
  use Review.Web, :webhook

  def create(conn, params) do
    handle_event conn, event_name(conn), params
  end

  defp handle_event(conn, "ping", _params) do
    conn |> text("pong")
  end

  defp handle_event(conn, "push", params) do
    params
    |> Poison.encode!
    |> Review.Repo.store_push
    |> Enum.each &broadcast_new_or_updated_commit/1

    conn |> text("ok")
  end

  defp handle_event(conn, "commit_comment", %{ "comment" => comment_data_with_string_keys }) do
    comment_data_with_string_keys
    |> Poison.encode!
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

  defp broadcast_new_or_updated_commit(commit) do
    Review.Endpoint.broadcast! "review", "new_or_updated_commit", Review.CommitSerializer.serialize(commit)
  end
end
