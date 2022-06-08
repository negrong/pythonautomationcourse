defmodule SmartBank.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:account