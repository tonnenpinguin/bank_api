defmodule BankAPI.Accounts.Projectors.AccountOpened do
  use Commanded.Projections.Ecto,
    name: "Accounts.Projectors.AccountOpened",
    application: BankAPI.App,
    repo: BankAPI.Repo,
    consistency: :strong

  alias BankAPI.Accounts.Events
  alias BankAPI.Accounts.Projections.Account

  project(%Events.AccountOpened{} = event, fn multi ->
    Ecto.Multi.insert(multi, :account_opened, %Account{
      uuid: event.account_uuid,
      current_balance: event.initial_balance,
      status: :open
    })
  end)
end
