defmodule Imcon.Repo.Migrations.CreateChannel do

  use Ecto.Migration

  def change do

    create table(:channel) do
      add :name, :string, null: false
      add :type, :integer

      timestamps()

    end

    create unique_index(:channel, [:name])

  end
end
