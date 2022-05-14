defmodule BankAPI.Accounts.Commands.TransferBetweenAccounts do
  use Ecto.Schema
  alias Ecto.Changeset
  alias BankAPI.Accounts
  alias BankAPI.Accounts.Projections.Account

  @enforce_keys [:account_uuid, :transfer_uuid]
  embedded_schema do
    field :account_uuid, Ecto.UUID
    field :transfer_uuid, Ecto.UUID
    field :transfer_amount, :integer
    field :destination_account_uuid, Ecto.UUID
  end

  @attrs [:transfer_amount, :destination_account_uuid]
  def validate(%__MODULE__{} = command) do
    params = Map.from_struct(command)

    %__MODULE__{account_uuid: command.account_uuid, transfer_uuid: command.transfer_uuid}
    |> Changeset.cast(params, @attrs)
    |> Changeset.validate_required(@attrs)
    |> Changeset.validate_number(:transfer_amount, greater_than: 0)
    |> Changeset.validate_change(:destination_account_uuid, fn :destination_account_uuid,
                                                               destination_account_uuid ->
      case Accounts.get_account(destination_account_uuid) do
        {:ok, %Account{status: :open}} ->
          []

        {:ok, %Account{}} ->
          [destination_account_uuid: "Destination account closed"]

        {:error, :not_found} ->
          [destination_account_uuid: "Destination account does not exist"]
      end
    end)
  end
end
