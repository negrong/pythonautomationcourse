
defmodule SmartBank.Bank.Report do
  @moduledoc """
  Custom queries for Bank context 
  """
  import Ecto.Query

  alias SmartBank.Bank.{Account, Transaction}

  @now Timex.now()

  def list_accounts_preloaded do
    from accounts in Account,
      preload: [:user, :wallet]
  end

  def get_all_transactions_today do
    today = @now |> Timex.to_date()

    from transactions in Transaction,
      where: fragment("date(inserted_at) = ?", ^today)
  end

  def get_all_transactions_month do
    {beginning_date, end_date} = get_range_month()

    from transactions in Transaction,
      where: fragment("date(inserted_at) between ? and ?", ^beginning_date, ^end_date)
  end

  def get_all_transactions_year do
    {beginning_date, end_date} = get_range_year()

    from transactions in Transaction,
      where: fragment("date(inserted_at) between ? and ?", ^beginning_date, ^end_date)
  end

  def get_range_month do