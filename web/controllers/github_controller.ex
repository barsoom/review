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
  defp handle_event(conn, "commit_comment", %{ "comment" => comment_json }) do
    comment_data = Poison.decode!(comment_json, keys: :atoms)

    # TODO: figure out how to keep authors in sync by username and email
    author = nil #Review.Repo.find_or_insert_author_by_username(comment_data.user.login)

    IO.inspect comment: %Review.Comment{
      github_id: comment_data.id,
      payload: "not-used-by-the-elixir-app",
      json_payload: comment_json,
      commit_sha: comment_data.commit_id,
      author: author,
    }

    conn |> text("ok")
  end

  defp event_name(conn) do
    conn.req_headers
      |> Enum.into(%{})
      |> Map.fetch!("x-github-event")
  end
end
