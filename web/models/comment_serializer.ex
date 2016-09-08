defmodule Exremit.CommentSerializer do
  def serialize(comments) when is_list(comments) do
    comments |> Parallel.pmap(&serialize/1)
  end

  def serialize(comment) do
    %{
      id: comment.id,
      timestamp: payload.timestamp,
    }
  end

  def payload do
    # TODO: implement json_payload
    %{
      timestamp: "2016-01-25T08:41:25+01:00"
    }
  end
end
