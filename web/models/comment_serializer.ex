defmodule Exremit.CommentSerializer do
  def serialize(comments) when is_list(comments) do
    comments |> Parallel.pmap(&serialize/1)
  end

  def serialize(comment) do
    %{
      id: comment.id
    }
  end
end
