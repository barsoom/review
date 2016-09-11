defmodule Review.Author do
  use Review.Web, :model

  schema "authors" do
    field :name, :string
    field :email, :string
    field :username, :string
    field :created_at, Ecto.DateTime
    field :updated_at, Ecto.DateTime
  end
end

