defmodule BankAPI.Accounts.Commands.WithdrawFromAccount do
  use Ecto.Schema
  alias Ecto.Changeset

  @enforce_keys [:account_uuid]
  embedded_schema do
    field :account_uuid, Ecto.UUID
    field :withdraw_amount, :integer
  end

  def validate(%__MODULE__{} = command) do
    params = Map.from_struct(command)

    %__MODULE__{account_uuid: command.account_uuid}
    |> Changeset.cast(params, [:withdraw_amount])
    |> Changeset.validate_required([:withdraw_amount])
    |> Changeset.validate_number(:withdraw_amount, greater_than: 0)
  end
end
