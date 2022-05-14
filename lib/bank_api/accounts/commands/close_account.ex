defmodule BankAPI.Accounts.Commands.CloseAccount do
  alias Ecto.Changeset
  use Ecto.Schema

  @enforce_keys [:account_uuid]

  embedded_schema do
    field :account_uuid, Ecto.UUID
  end

  def validate(%__MODULE__{} = command) do
    params = Map.from_struct(command)

    %__MODULE__{account_uuid: command.account_uuid}
    |> Changeset.cast(params, [:account_uuid])
  end
end
