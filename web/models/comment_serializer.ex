defmodule Exremit.CommentSerializer do
  def serialize(comments) when is_list(comments) do
    comments |> Parallel.pmap(&serialize/1)
  end

  def serialize(comment) do
    payload = parse_payload(comment)

    %{
      id: comment.id,
      timestamp: payload.created_at,
      commitAuthorGravatar: commit_author_gravatar(comment.commit),
      commitAuthorName: commit_author_name(comment.commit),
      body: payload.body,
    }
  end

  def commit_author_gravatar(nil), do: nil
  def commit_author_gravatar(commit) do
    gravatar_hash(commit.author)
  end

  defp commit_author_name(nil), do: nil
  defp commit_author_name(commit) do
    commit.author.name
  end

  defp gravatar_hash(nil), do: gravatar_hash(%{ email: "show-a-placeholder" })
  defp gravatar_hash(author) do
    Gravatar.hash(author.email)
  end

  defp parse_payload(comment) do
    Poison.decode!(comment.json_payload, keys: :atoms)
  end
end
