defmodule SmartBankWeb.Gettext do
  @moduledoc """
  A module providing Internationalization with a gettext-based API.

  By using [Gettext](https://hexdocs.pm/gettext),
  your module gains a set of macros for translations, for example:

      import SmartBankWeb.Gettext

      # Simple translation
      gettext("Here is the string to