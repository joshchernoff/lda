defmodule LDA.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LDAWeb.Telemetry,
      LDA.Repo,
      {DNSCluster, query: Application.get_env(:lda, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LDA.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LDA.Finch},
      # Start a worker by calling: LDA.Worker.start_link(arg)
      # {LDA.Worker, arg},
      # Start to serve requests, typically the last entry
      LDAWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LDA.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LDAWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
