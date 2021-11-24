
defmodule SmartBank.Authentication.User do
  @moduledoc """
  User entity, responsible for authentication data persistence
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    has_one :account, SmartBank.Bank.Account
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :active, :boolean, default: true

    timestamps()
  end

  @required_fields ~w(email password)a

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)