defmodule BankAPI.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Supervisor.child_spec(BankAPI.Accounts.Projectors.AccountOpened, id: :account_opened),
    children = [
      BankAPI.Repo,
      BankAPI.App,
      BankAPI.Accounts.Supervisor,
      BankAPIWeb.Telemetry,
      {Phoenix.PubSub, name: BankAPI.PubSub},
      BankAPIWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BankAPI.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BankAPIWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
