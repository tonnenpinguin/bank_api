defmodule BankAPI.Accounts.Commands.OpenAccount do
  alias Ecto.Changeset
  use Ecto.Schema

  @enforce_keys [:account_uuid]

  embedded_schema do
    field :account_uuid, Ecto.UUID
    field :initial_balance, :integer
  end

  def validate(%__MODULE__{} = command) do
    params = Map.from_struct(command)

    %__MODULE__{account_uuid: command.account_uuid}
    |> Changeset.cast(params, [:account_uuid, :initial_balance])
    |> Changeset.validate_required([:initial_balance])
    |> Changeset.validate_number(:initial_balance, greater_than: 0)
  end
end
