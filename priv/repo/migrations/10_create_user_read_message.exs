defmodule Imcon.Repo.Migrations.CreateUserReadMessage do
  use Ecto.Migration

  def change do
    create table(:user_read_message) do
      add :message_id, :integer
      add :latest_ts, :utc_datetime
      add :user_id, references(:user, on_delete: :nilify_all)
      add :channel_id, references(:channel, on_delete: :nilify_all)

      timestamps()
    end
    create unique_index(:user_read_message, [:user_id, :channel_id])

  end
end
