defmodule SmartBank.UtilsTest do
  use ExUnit.Case

  import SmartBank.Utils, only: [recursive_struct_to_map: 1]

  alias SmartBank.Bank.Account

  test "recursive struct hand