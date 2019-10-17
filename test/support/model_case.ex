defmodule Review.ModelCase do
  @moduledoc """
  This module defines the test case to be used by
  model tests.

  You may define functions here to be used as helpers in
  your model tests. See `errors_on/2`'s definition as reference.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Review.Repo
      import Ecto.Schema
      import Ecto.Query, only: [from: 2]
      import Review.ModelCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Review.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Review.Repo, {:shared, self})
    end

    :ok
  end

  @doc """
  Helper for returning list of errors in model when passed certain data.

  ## Examples

  Given a User model that lists `:name` as a required field and validates
  `:password` to be safe, it would return:

      iex> errors_on(%User{}, %{password: "password"})
      [password: "is unsafe", name: "is blank"]

  You could then write your assertion like:

      assert {:password, "is unsafe"} in errors_on(%User{}, %{password: "password"})

  You can also create the changeset manually and retrieve the errors
  field directly:

      iex> changeset = User.changeset(%User{}, password: "password")
      iex> {:password, "is unsafe"} in changeset.errors
      true
  """
  def errors_on(model, data) do
    model.__struct__.changeset(model, data).errors
  end
end
