defmodule SmartBank.AuthTest do
  use SmartBank.DataCase

  alias SmartBank.Authentication
  alias SmartBank.Authentication.User

  import SmartBank.Factory

  @valid_user_attrs %{"email" => Faker.Internet.email(), "password" => Faker.String.base64()}

  describe "users