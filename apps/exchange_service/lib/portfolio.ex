defmodule ExchangeService.Portfolio do
  use GenServer

  alias ExchangeService.Stock

  @moduledoc """
    The Portfolio Agent is a wrapper around the portfolio state
    of a given ExchangeService. It keeps a map of all the current
    values of the stocks with their last update timestamp on the
    site of the exchange.
  """

  @type state :: %{atom() => Stock.t()}

  @spec init(state()) :: {:ok, state()}
  def init(assigned_portfolio) do
    {:ok, assigned_portfolio}
  end

  def get(portfolio, id) do
    Agent.get(portfolio, &Map.get(&1, id))
  end

  def update(portfolio, id, value) do
    :logger.info "Updated Stock: [ #{id} ]: $#{value / 100}"
    timestamp = System.os_time()
    Agent.update(portfolio, &Map.put(&1, id, {value, timestamp}))
    {id, value, timestamp}
  end

end
