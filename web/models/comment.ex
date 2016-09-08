defmodule Exremit.Comment do
  use Exremit.Web, :model

  schema "comments" do
    # TODO: add json payload
    field :payload, :string
    field :github_id, :integer

    timestamps inserted_at: :created_at

    field :json_payload, :string
    belongs_to :commit, Exremit.Commit, foreign_key: :commit_sha, references: :sha, type: :string
    belongs_to :author, Exremit.Author
    belongs_to :resolved_by_author, Exremit.Author
  end
end
