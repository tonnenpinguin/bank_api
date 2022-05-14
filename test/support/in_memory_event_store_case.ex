defmodule BankAPI.Test.InMemoryEventStoreCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Commanded.Assertions.EventAssertions
      import BankAPI.Test.AggregateUtils
    end
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(BankAPI.Repo, shared: not tags[:async])

    on_exit(fn ->
      Ecto.Adapters.SQL.Sandbox.stop_owner(pid)
      :ok = Application.stop(:bank_api)
      :ok = Application.stop(:commanded)
      {:ok, _apps} = Application.ensure_all_started(:bank_api)
    end)
  end
end
