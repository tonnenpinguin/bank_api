defmodule BankAPI.Repo.Migrations.IntroduceAccountStatus do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :status, :text
    end
  end
end
