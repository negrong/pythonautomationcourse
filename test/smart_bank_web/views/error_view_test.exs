defmodule SmartBankWeb.ErrorViewTest do
  use SmartBankWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(SmartBankWeb.ErrorView, "404.json", error: "Not Found") == %{
             errors: %{detail: "Not Found"}
           }

    assert render(SmartBankWeb.ErrorView, "404.json", []) == %{errors: %{detail: "Route not found"}}
  end

  test "renders 500.json" do
    assert render(SmartBankWeb.ErrorView, "500.json", error: "Internal Server Error") ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
