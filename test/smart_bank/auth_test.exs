defmodule SmartBank.AuthTest do
  use SmartBank.DataCase

  alias SmartBank.Authentication
  alias SmartBank.Authentication.User

  import SmartBank.Factory

  @valid_us