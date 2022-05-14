defmodule BankAPI.Accounts.Commands.DepositIntoAccount do
  use Ecto.Schema
  alias Ecto.Changeset

  @enforce_keys [:account_uuid]
  embedded_schema do
    field :account_uuid, Ecto.UUID
    field :deposit_amount, :integer
  end

  def validate(%__MODULE__{} = command) do
    params = Map.from_struct(command)

    %__MODULE__{account_uuid: command.account_uuid}
    |> Changeset.cast(params, [:deposit_amount])
    |> Changeset.validate_required([:deposit_amount])
    |> Changeset.validate_number(:deposit_amount, greater_than: 0)
  end
end
