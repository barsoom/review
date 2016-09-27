defmodule Review.Comment do
  use Review.Web, :model

  schema "comments" do
    field :github_id, :integer
    field :payload, :string
    field :json_payload, :string
    timestamps inserted_at: :created_at

    belongs_to :commit, Review.Commit, foreign_key: :commit_sha, references: :sha, type: :string
    belongs_to :author, Review.Author
    belongs_to :resolved_by_author, Review.Author
  end
end
