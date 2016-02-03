defmodule Exremit.CommitSerializer do
  def serialize(commits) when is_list(commits) do
    commits |> Enum.map &serialize/1
  end

  def serialize(commit) do
    %{
      id: commit.id,
    }
  end
end
