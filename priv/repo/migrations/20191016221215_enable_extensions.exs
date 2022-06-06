defmodule SmartBank.Repo.Migrations.EnableExtensions do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS \"uuid-os