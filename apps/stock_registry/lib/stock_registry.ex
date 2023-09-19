defmodule StockRegistry do
  use Supervisor

  # alias StockRegistry.Exchanges
  # alias StockRegistry.Portfolios
  # alias StockRegistry.Stocks

  @moduledoc """

    This server manages all of the configurations and its distribution to the different nodes. A node -- either
    bank or exchange -- can register with this service and recieve a configuration to run upon.
    This way we dont need to configure all different services decentralized and reduce code duplication.

  """

  @impl true
  def init(:ok) do
    # Before starting the supervisor - connect to the distributed system
    with {:ok, _pid} <- Node.start :registry, :shortnames  do

      # Child processes, that will be supervised:
      children = [
        # To keep track of the nodes / processes, who registered certain stocks,
        # exchanges or banks, the built-in Registry keeps track of the processes
        # managing these resources.
        {Registry, [:unique, :portfolio_registry], name: PortfolioRegistry},
        {Registry, [:unique, :exchange_registry], name: ExchangeRegistry},
        {Registry, [:unique, :stock_registry], name: StockRegistry},

        # To handle the
        {StockRegistry.Registrar, []},
      ]
      Supervisor.init children, [strategy: :one_for_one, name: Registry.Supervisor]
    else
      # Catch any error, that occured on the connection
      {:error, _} ->
        :logger.error "Cannot connect registry to distributed system."
        :ignore
    end
  end

  defmodule Registrar do
    use Applicaiton

    :e



  end

  # @spec init(:ok) :: {:ok, {exchs(), banks()}}
  # def init(:ok) do

  #   Registry.

  #   {:ok, {%{}, %{}}}
  # end

end
