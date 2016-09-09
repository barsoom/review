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
    }
  end

  defp parse_payload(comment) do
    Poison.decode!(comment.json_payload, keys: :atoms)
  end
end
