defmodule Review.StoreCommitComment do
  def call(comment_json) do
    comment_json
    |> parse_json
    |> build_comment
    |> add_author
    |> insert_comment
    |> load_associations
  end

  defp parse_json(comment_json) do
    comment_data = Jason.decode!(comment_json, keys: :atoms)
    {comment_json, comment_data}
  end

  defp build_comment({comment_json, comment_data}) do
    comment = %Review.Comment{
      github_id: comment_data.id,
      payload: "not-used-by-the-elixir-app",
      json_payload: comment_json,
      commit_sha: comment_data.commit_id
    }

    {comment, comment_data}
  end

  defp add_author({comment, comment_data}) do
    author = Review.Repo.insert_or_update_author(%{username: comment_data.user.login})
    Map.put(comment, :author, author)
  end

  defp insert_comment(comment) do
    Review.Repo.insert(comment)
  end

  defp load_associations({:ok, comment}) do
    Review.Repo.get!(Review.Repo.comments(), comment.id)
  end
end
