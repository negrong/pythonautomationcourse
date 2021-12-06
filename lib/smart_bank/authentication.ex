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

  ## Examples

      iex> get_user(user_id)
      %User{}


  """
  def get_user(user_id) do
    User
    |> Repo.get(user_id)
    |> Repo.preload([:account])
    |> format_response()
  end

  defp format_response(%User{} = user), do: {:ok, user}
  defp format_response(_), do: {:error, "User not found", 404}

  @doc """
  Return one user by email.

  ## Examples

      iex> get_user(user_id)
      %User{}


  """
  def get_user_by_email(email) do
    User
    |> Repo.get_by(email: email)
    |> Repo.preload([:accoun