defmodule BankAPI.ProjectorCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias BankAPI.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import BankAPI.DataCase

      import BankAPI.Test.ProjectorUtils
    end
  end

  setup tags do
    :ok = BankAPI.Test.ProjectorUtils.truncate_database()

    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(BankAPI.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
    :ok
  end
end
