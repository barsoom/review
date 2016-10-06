defmodule Review.AuthorQuery do
  import Ecto.Query
  alias Review.{Repo, Author}

  def insert_or_update_author(params) do
    build_insert_query(params)
    |> Repo.one
    |> insert_or_update_author(params)
  end

  defp build_insert_query(%{username: username}), do: Author |> where(username: ^username)
  defp build_insert_query(%{email: email}),       do: Author |> where(email: ^email)

  defp insert_or_update_author(nil, params), do: %Author{} |> insert_or_update_author(params)
  defp insert_or_update_author(author, params) do
    author
    |> Author.changeset(params)
    |> Repo.insert_or_update!
  end
end
