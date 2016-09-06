defmodule Exremit.CommitCache do
  def fetch(commit, fun) do
    key = "#{commit.sha}-#{commit.updated_at}"

    json = Cachex.get!(:commit_cache, key) || fun.(commit)

    # Keep any seen commit for a while, but not forever
    Cachex.set!(:commit_cache, key, json, [ ttl: ttl ])

    json
  end

  defp ttl, do: :timer.minutes(60 * 24) * 7
end
