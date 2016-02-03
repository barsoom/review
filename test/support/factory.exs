defmodule Exremit.Factory do
  use ExMachina.Ecto, repo: Exremit.Repo

  alias Exremit.Commit
  alias Exremit.Author

  def factory(:author) do
    %Author{ name: "Joe", email: "joe@example.com", username: "joe" }
  end

  def factory(:commit) do
    %Commit{ sha: "2107c5d7b290c0ca294d4d70029e87b599bc9152", payload: "only-used-by-the-ruby-app", json_payload: commit_payload, author: build(:author) }
  end

  # This payload is actually the commit payload + repository from the push payload, but that is
  # what we save in the database.
  defp commit_payload do
    File.read!("test/fixtures/payload.json")
  end
end
