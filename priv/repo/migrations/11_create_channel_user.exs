defmodule Imcon.Repo.Migrations.CreateChannelUser do
  use Ecto.Migration

  def change do
    create table(:channel_user) do
      add :joined_at, :utc_datetime
      add :channel_id, references(:channel, on_delete: :nilify_all)
      add :user_id, references(:user, on_delete: :nilify_all)

      timestamps()
    end

    create index(:channel_user, [:channel_id, :user_id], unique: true)

  end
end
