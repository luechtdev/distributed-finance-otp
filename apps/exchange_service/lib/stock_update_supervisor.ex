defmodule ExchangeService.StockUpdateSupervisor do
  use DynamicSupervisor

  alias ExchangeService.StockUpdateGenerator

  def start_link(portfolio, interval) do
    DynamicSupervisor.start_link __MODULE__, {portfolio, interval}, name: __MODULE__
  end

  @impl true
  def init({portfolio, interval}) do
    DynamicSupervisor.init strategy: :one_for_one

    # For each stock in the portfolio
    for s <- Map.keys portfolio do
      {:ok, stock_info} = Map.fetch portfolio, s

      child_spec = {StockUpdateGenerator, stock_info}
      DynamicSupervisor.start_child __MODULE__, child_spec

    end
  end

end
