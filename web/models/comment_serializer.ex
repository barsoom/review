defmodule Exremit.CommentSerializer do
  def serialize(comments) when is_list(comments) do
    comments |> Parallel.pmap(&serialize/1)
  end

  def serialize(comment) do
    payload = parse_payload(comment)

    %{
      id: comment.id,
      timestamp: payload.created_at,
      authorName: comment.author.name,
      authorGravatar: gravatar_hash(comment.author),
      commitAuthorGravatar: commit_author_gravatar(comment.commit),
      commitAuthorName: commit_author_name(comment.commit),
      commitSummary: commit_summary(comment.commit),
      resolved: !!comment.resolved_by_author,
      threadIdentifier: thread_identifier(payload),
      body: payload.body,
    }
  end

  def thread_identifier(payload) do
    [ payload.commit_id, payload.position, payload.line ] |> Enum.join(":")
  end

  def commit_summary(nil), do: nil
  def commit_summary(commit), do: Exremit.CommitSerializer.commit_summary(commit)

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
