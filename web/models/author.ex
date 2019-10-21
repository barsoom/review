defmodule Review.Author do
  use Review.Web, :model
  import Ecto.Changeset

  schema "authors" do
    field(:name, :string)
    field(:email, :string)
    field(:username, :string)
    field(:created_at, Ecto.DateTime)
    field(:updated_at, Ecto.DateTime)
  end

  def changeset(author, params \\ %{}) do
    author
    |> cast(params, [:name, :email, :username])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end
end
