defmodule BankAPI.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        BankAPI.Repo,
        BankAPIWeb.Telemetry,
        {Phoenix.PubSub, name: BankAPI.PubSub},
        BankAPIWeb.Endpoint
      ] ++ additional_children()

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

  defp additional_children do
    if Process.whereis(EventStore.Config.Store),
      do: [BankAPI.EventStore],
      else: []
  end
end
