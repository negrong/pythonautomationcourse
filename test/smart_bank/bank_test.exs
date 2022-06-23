
defmodule SmartBank.BankTest do
  use SmartBank.DataCase

  alias SmartBank.Bank
  alias SmartBank.Bank.{Account}

  import ExUnit.CaptureIO
  import SmartBank.Factory

  @valid_user_attrs %{"email" => Faker.Internet.email(), "password" => Faker.String.base64()}