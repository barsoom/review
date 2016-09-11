defmodule Review.Comment do
  use Review.Web, :model

  schema "comments" do
    # TODO: add json payload
    field :payload, :string
    field :github_id, :integer

    timestamps inserted_at: :created_at

    field :json_payload, :string
    belongs_to :commit, Review.Commit, foreign_key: :commit_sha, references: :sha, type: :string
    belongs_to :author, Review.Author
    belongs_to :resolved_by_author, Review.Author
  end
end
