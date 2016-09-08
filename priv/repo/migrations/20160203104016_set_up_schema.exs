defmodule Exremit.Repo.Migrations.SetUpSchema do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :name, :string
      add :email, :string
      add :username, :string
      add :created_at, :datetime
      add :updated_at, :datetime
    end

    create table(:comments) do
      add :payload, :text, null: false
      add :created_at, :datetime
      add :updated_at, :datetime
      add :github_id, :integer, null: false
      add :commit_sha, :string, null: false
      add :author_id, :integer, null: false
      add :resolved_at, :datetime
      add :resolved_by_author_id, :integer
      add :cached_data, :text
      add :json_payload, :text, null: false
    end

    create index(:comments, [:author_id])
    create index(:comments, [:commit_sha])
    create index(:comments, [:github_id])
    create index(:comments, [:resolved_by_author_id])

    create table(:commits) do
      add :sha, :string, null: false
      add :payload, :text, null: false
      add :json_payload, :text, null: false
      add :created_at, :datetime
      add :updated_at, :datetime
      add :reviewed_at, :datetime
      add :author_id, :integer, null: false
      add :reviewed_by_author_id, :integer
      add :review_started_at, :datetime
      add :review_started_by_author_id, :integer
      add :cached_data, :text
    end

    create index(:commits, [:author_id])
    create index(:commits, [:review_started_by_author_id])
    create index(:commits, [:reviewed_by_author_id])
    create index(:commits, [:sha])
  end
end
