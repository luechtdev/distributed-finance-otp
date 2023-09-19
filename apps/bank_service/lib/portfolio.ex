defmodule BankService.Portfolio do
  use Agent

  @moduledoc """
    The Portfolio Agent is a wrapper around the portfolio state
    of a given ExchangeService. It keeps a map of all the current
    values of the stocks with their last update timestamp on the
    site of the exchange.
  """

  @type last_value :: {number(), integer()}
  @type t :: %{atom() => last_value()}

  def init do
    Agent.start_link fn -> %{} end, name: __MODULE__
  end

  @spec get(t(), atom()) :: last_value()
  def get(portfolio, id) do
    Agent.get portfolio, &Map.get(&1, id)
  end

  @spec update(t(), atom(), number()) :: {atom(), number(), integer()}
  def update(portfolio, id, value) do
    :logger.info "Updated Stock: [ #{id} ]: $#{value / 100}"
    timestamp = System.os_time
    Agent.update portfolio, &Map.put(&1, id, {value, timestamp})
    {id, value, timestamp}
  end

end
