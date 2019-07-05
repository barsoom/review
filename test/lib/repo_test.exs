defmodule Review.RepoTest do
  use Review.ModelCase

  test "insert_or_update_author: can persist and find an author by email or username" do
    author =
      Repo.insert_or_update_author(%{email: "foo@example.com", username: "foo", name: "Foo"})

    assert author.id > 0
    assert author.name == "Foo"
    assert author.username == "foo"
    assert author.email == "foo@example.com"

    author2 =
      Repo.insert_or_update_author(%{email: "foo@example.com", username: "foo", name: "Foo"})

    assert author.id == author2.id

    author2 = Repo.insert_or_update_author(%{email: "foo@example.com"})
    assert author.id == author2.id

    author2 = Repo.insert_or_update_author(%{username: "foo"})
    assert author.id == author2.id
  end

  # This would only happen if a comment arrives for a commit we don't know
  # about, i.e. a commit created before you started using this app.
  test "insert_or_update_author: allows duplicates when it can't be avoided" do
    # Github comment hook only gives us username
    author1 = Repo.insert_or_update_author(%{username: "foo"})

    # Mark-as-resolved only gives us email
    author2 = Repo.insert_or_update_author(%{email: "foo@example.com"})

    assert author1.id != author2.id
  end
end
