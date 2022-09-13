defmodule SmartBankWeb.ErrorViewTest do
  use SmartBankWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(SmartBankWeb.ErrorView, "404.json", error: "Not Found") == %{
             errors: %{detail: "Not Found"}
           }

    assert render(SmartBankWeb.ErrorView, "4