
defmodule SmartBank.Factory do
  @moduledoc """
    Module responsible to provide helper funcions for entity creations on tests
  """
  import SmartBank.Utils, only: [recursive_struct_to_map: 1]

  alias SmartBank.Authentication
  alias SmartBank.Bank
  alias SmartBank.Repo

  def jwt_account_token do
    user = insert(:user)
    account = insert(:account, context: %{user: user})
    insert(:wallet, context: %{account: account, amount: 2000})
    {:ok, jwt_account_token, _} = Authentication.Guardian.encode_and_sign(user)
    jwt_account_token
  end

  def jwt_account_token(%{user: %SmartBank.Authentication.User{} = user}) do
    {:ok, jwt_account_token, _} = Authentication.Guardian.encode_and_sign(user)
    jwt_account_token
  end

  defp entity(_context, :user) do
    %Authentication.User{
      email: Faker.Internet.email(),
      password_hash: Faker.String.base64()
    }
  end

  defp entity(context, :account) do
    %Bank.Account{
      name: Faker.Name.name(),
      user: get_assoc(context, :user)
    }
  end

  defp entity(context, :transaction) do
    %Bank.Transaction{
      account: get_assoc(context, :account),
      amount: 10..100 |> Enum.random() |> Money.new()
    }
  end

  defp entity(context, :wallet) do
    %Bank.Wallet{
      account: get_assoc(context, :account),
      amount: 10..100 |> Enum.random() |> Money.new()
    }
  end

  # Convenience API

  @doc """
  Builds an entity with fake data in memory. It is NOT persisted to DB (use insert for that).

  Optionally, you can pass a `context` map and an `attributes` map/keyword list as extra
  arguments.

  The context can be used in the entity functions to enforce specific rules or associations.

  Attributes are used to override parameters with custom data.

  Returns a struct.
  """

  def build(factory), do: build(factory, %{}, [])
  def build(factory, context: %{} = context), do: build(factory, context, [])
  def build(factory, attributes), do: build(factory, %{}, attributes)

  def build(factory, context, attributes) when is_atom(factory) and is_map(context) do
    context |> entity(factory) |> filter_overridden(attributes) |> struct(attributes)
  end

  @doc """
  Builds an entity with fake data and persists it to database.

  Refer to `build/1` for optional arguments.

  Returns a struct.
  """
  def insert(factory), do: insert(factory, %{}, [])
  def insert(factory, context: %{} = context), do: insert(factory, context, [])
  def insert(factory, attributes), do: insert(factory, %{}, attributes)

  def insert(factory, context, attributes) when is_atom(factory) and is_map(context) do
    Repo.insert!(build(factory, context, attributes))
  end

  @doc """
  Same as `build/1`, except it generates raw maps of attributes, even for nested structs.

  This allows generation of attribute maps to test domain calls. (structs cannot be passed to
  changesets)

  Returns a map.
  """
  def attrs(factory), do: attrs(factory, %{}, [])
  @spec attrs(:account | :transaction, maybe_improper_list) :: map
  def attrs(factory, context: %{} = context), do: attrs(factory, context, [])
  def attrs(factory, attributes) when is_list(attributes), do: attrs(factory, %{}, attributes)
  @spec attrs(:account | :transaction, map, any) :: map
  def attrs(factory, context, attributes) when is_atom(factory) and is_map(context) do
    factory |> build(context) |> recursive_struct_to_map() |> Map.merge(Map.new(attributes))
  end
