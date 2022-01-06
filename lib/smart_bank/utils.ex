defmodule SmartBank.Utils do
  @moduledoc """
  Utility functions.
  """

  @doc """
  Recursively transforms a struct and its nested structs into maps.
  Preserves structs outside of the "SmartBank.*" namespace (such as DateTime).
  """
  def recursive_struct_to_map(%{__struct__: type} = struct) do
    base_namespace = type |> Module.split() |> List.first()

    case base_namespace do
      "SmartBank" -> struct |> Map.from_struct() |> recursive_struct_to_map()
      _ -> struct
    end
  end

  def recursi