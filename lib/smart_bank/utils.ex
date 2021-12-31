defmodule SmartBank.Utils do
  @moduledoc """
  Utility functions.
  """

  @doc """
  Recursively transforms a struct and its nested structs into maps.
  Preserves structs outside of the "SmartBank.*" namespace (such as DateTime).
  """
  def recursive_stru