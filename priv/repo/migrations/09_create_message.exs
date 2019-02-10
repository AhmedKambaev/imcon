defmodule Imcon.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:message) do
      add :text, :text, null: false
      add :channel_id, references(:channel), null: false
      add :user_id, references(:user), null: false

      timestamps()
    end
    create index(:message, [:channel_id, :user_id])

  end
end
