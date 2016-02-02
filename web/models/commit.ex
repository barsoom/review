defmodule Exremit.Commit do
  use Exremit.Web, :model

  schema "commits" do
    field :sha, :string
    field :payload, :string
    field :created_at, Ecto.DateTime
    field :updated_at, Ecto.DateTime
    field :reviewed_at, Ecto.DateTime
    field :review_started_at, Ecto.DateTime

    belongs_to :author, Exremit.Author
    belongs_to :reviewed_by_author, Exremit.Author
  end
end
