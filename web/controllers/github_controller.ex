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

  # WIP: handle comments payload
  defp handle_event(conn, "commit_comment", %{ "comment" => comment_data_with_string_keys }) do
    comment_data = AtomicMap.convert(comment_data_with_string_keys, safe: false)

    # TODO: figure out how to keep authors in sync by username and email
    author = Review.Repo.find_or_insert_author_by_username(comment_data.user.login)

    comment = %Review.Comment{
      github_id: comment_data.id,
      payload: "not-used-by-the-elixir-app",
      json_payload: Poison.encode!(comment_data),
      commit_sha: comment_data.commit_id,
      author: author,
    }

    {:ok, comment} = Review.Repo.insert(comment)
    comment = Review.Repo.get!(Review.Repo.comments, comment.id)

    Review.Endpoint.broadcast! "review", "new_or_updated_comment", Review.CommentSerializer.serialize(comment)

    conn |> text("ok")
  end

  defp event_name(conn) do
    conn.req_headers
      |> Enum.into(%{})
      |> Map.fetch!("x-github-event")
  end
end
