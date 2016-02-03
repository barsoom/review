defmodule Exremit.Factory do
  use ExMachina.Ecto, repo: Exremit.Repo

  alias Exremit.Commit
  alias Exremit.Author

  def factory(:author) do
    %Author{ name: "Joe", email: "joe@example.com", username: "joe" }
  end

  def factory(:commit) do
    %Commit{ sha: "2107c5d7b290c0ca294d4d70029e87b599bc9152", payload: "todo-add-real-payload-when-needed", author: build(:author) }
  end
end
