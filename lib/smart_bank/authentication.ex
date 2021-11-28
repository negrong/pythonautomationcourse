defmodule SmartBank.Authentication do
  @moduledoc """
    Main module of Authentication context.
    This module has the authetication functions and user management functions
  """
  import Ecto.Query, warn: false
  alias SmartBank.Repo
  alias SmartBank.Authentication.{Guardian, User}

  @doc """
  Return one user by id.

  ## E