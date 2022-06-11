defmodule SmartBank.AuthTest do
  use SmartBank.DataCase

  alias SmartBank.Authentication
  alias SmartBank.Authentication.User

  import SmartBank.Factory

  @valid_user_attrs %{"email" => Faker.Internet.email(), "password" => Faker.String.base64()}

  describe "users" do
    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Authentication.create_user(@valid_user_attrs)
      assert user.email == @valid_user_attrs[