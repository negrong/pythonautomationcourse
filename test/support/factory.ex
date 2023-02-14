
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