defmodule BankAPI.Accounts.Projections.Account do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  schema "accounts" do
    field :current_balance, :integer
    field :status, Ecto.Enum, values: [:open, :closed], default: :open

    timestamps()
  end
end
