defmodule Review.ApiController do
  use Review.Web, :api

  alias Review.{Repo, Commit}
  import Ecto.Query

  def unreviewed_commit_stats(conn, _params) do
    query =
      from(c in Commit,
        where: is_nil(c.reviewed_at),
        select: %{count: count(c.id), oldest_created_at: min(c.created_at)}
      )

    data = Repo.one(query)
    data = convert_oldest_created_at_to_oldest_age_in_seconds(data)

    conn |> json(data)
  end

  defp convert_oldest_created_at_to_oldest_age_in_seconds(data) do
    oldest_created_at = Map.get(data, :oldest_created_at)
    oldest_age_in_seconds = oldest_age_in_seconds(oldest_created_at)

    data
    |> Map.delete(:oldest_created_at)
    |> Map.put(:oldest_age_in_seconds, oldest_age_in_seconds)
  end

  defp oldest_age_in_seconds(nil), do: nil

  defp oldest_age_in_seconds(oldest_created_at) do
    {:ok, oldest_age_in_seconds, _, _} =
      Calendar.NaiveDateTime.diff(
        Ecto.DateTime.to_erl(Ecto.DateTime.utc()),
        NaiveDateTime.to_erl(oldest_created_at)
      )

    oldest_age_in_seconds
  end
end
