defmodule Review.StorePush do
  alias Review.{Commit}

  def call(push_json) do
    push_json
    |> parse_json
    |> build_and_insert_commits
  end

  defp parse_json(push_json) do
    Poison.decode!(push_json, keys: :atoms)
  end

  defp build_and_insert_commits(push_data = %{ ref: ref, repository: %{ master_branch: master_branch } }) do
    branch = String.split(ref, "/") |> Enum.reverse |> hd

    # Ignore commits outside the master branch.
    # It's usually experimental work in progress and not ready for review.
    if branch == master_branch do
      push_data
      |> build_commits_and_authors
      |> insert_commits
      |> load_associations
    else
      []
    end
  end

  defp build_commits_and_authors(push_data) do
    push_data.commits
    |> Enum.map(fn (commit_data) ->
      build_commit(commit_data, push_data)
      |> add_author(commit_data)
    end)
  end

  defp build_commit(commit_data, push_data) do
    json_payload =
      Map.put(commit_data, :repository, push_data.repository)
      |> Poison.encode!

    %Commit{
      payload: "not-used-by-the-elixir-app",
      json_payload: json_payload,
      sha: commit_data.id,
    }
  end

  defp add_author(commit, commit_data) do
    raw_author_data = commit_data.author

    author =
      %{
        email: raw_author_data.email,
        name: raw_author_data.name
      }
      |> add_username(raw_author_data)
      |> Review.Repo.insert_or_update_author

    Map.put(commit, :author, author)
  end

  defp insert_commits(commits) do
    commits
    |> Enum.map(&Review.Repo.insert!/1)
  end

  defp load_associations(commits) do
    commits
    |> Enum.map(fn (commit) ->
      Review.Repo.get!(Review.Repo.commits, commit.id)
    end)
  end

  # Pair commits does not have username
  defp add_username(author_data, %{username: username}) do
    Map.put(author_data, :username, username)
  end
  defp add_username(author_data, _raw_author_data) do
    author_data
  end
end
