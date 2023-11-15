defmodule ProkeepTechnicalChallenge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ProkeepTechnicalChallengeWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:prokeep_technical_challenge, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ProkeepTechnicalChallenge.PubSub},
      # Start a worker by calling: ProkeepTechnicalChallenge.Worker.start_link(arg)
      # {ProkeepTechnicalChallenge.Worker, arg},
      # Start to serve requests, typically the last entry
      ProkeepTechnicalChallengeWeb.Endpoint,
      ProkeepTechnicalChallenge.MessageTimersAgent
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ProkeepTechnicalChallenge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ProkeepTechnicalChallengeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
