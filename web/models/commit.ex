defmodule Review.Commit do
  use Review.Web, :model

  schema "commits" do
    field :sha, :string

    # This is the yaml payload the ruby app uses. It's difficult to load in elixir since is uses special syntax for symbols.
    field :payload, :string

    field :json_payload, :string
    field :reviewed_at, Ecto.DateTime
    field :review_started_at, Ecto.DateTime

    timestamps inserted_at: :created_at

    belongs_to :author, Review.Author
    belongs_to :reviewed_by_author, Review.Author
    belongs_to :review_started_by_author, Review.Author
  end
end
