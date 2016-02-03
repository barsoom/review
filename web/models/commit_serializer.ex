defmodule Exremit.CommitSerializer do
  # Some argue 50 chars is a good length for the summary part of a commit message.
  # http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
  @message_summary_length 50

  def serialize(commits) when is_list(commits) do
    commits |> Enum.map(&serialize/1)
  end

  def serialize(commit) do
    %{
      id: commit.id,
      summary: summary(commit),
    }
  end

  defp summary(commit) do
    message(commit)
    |> String.split("\n")
    |> List.first
    |> String.slice(0, @message_summary_length)
  end

  defp message(commit) do
    {:ok, message } =
      Exremit.JSON.decode(commit.json_payload)
      |> Map.fetch("message")

    message
  end
end
