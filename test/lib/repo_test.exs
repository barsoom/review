defmodule Exremit.RepoTest do
  use Exremit.ModelCase

  test "find_or_insert_by_email" do
    author1 = Repo.find_or_insert_author_by_email("foo@example.com")
    author2 = Repo.find_or_insert_author_by_email("foo@example.com")
    assert author1.id == author2.id
    assert author1.email == "foo@example.com"
  end
end
