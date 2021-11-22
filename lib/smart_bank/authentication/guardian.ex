defmodule SmartBank.Authentication.Guardian do
  @moduledoc false

  use Guardian, otp_app: :SmartBank

  alias SmartBank.Authentication

  def subject_for_token(user, _clai