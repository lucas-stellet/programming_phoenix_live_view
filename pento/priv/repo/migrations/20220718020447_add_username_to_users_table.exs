defmodule Pento.Repo.Migrations.AddUsernameToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string, null: true
    end

    execute """
      update
        users
      set
        username = split_part(users.email, '@', 1)
      where
        users.username is null;
    """

    alter table(:users) do
      modify :username, :string, null: false
    end

    create unique_index(:users, [:username])
  end
end
