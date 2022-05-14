defmodule BankAPI.Accounts.Commands.DepositIntoAccount do
  use Ecto.Schema
  alias Ecto.Changeset

  @enforce_keys [:account_uuid]
  embedded_schema do
    field :account_uuid, Ecto.UUID
    field :transfer_uuid, Ecto.UUID
    field :deposit_amount, :integer
  end

  @required_attrs [:deposit_amount]
  @all_attrs @required_attrs ++ [:transfer_uuid]

  def validate(%__MODULE__{} = command) do
    params = Map.from_struct(command)

    %__MODULE__{account_uuid: command.account_uuid}
    |> Changeset.cast(params, @all_attrs)
    |> Changeset.validate_required(@required_attrs)
    |> Changeset.validate_number(:deposit_amount, greater_than: 0)
  end
end
