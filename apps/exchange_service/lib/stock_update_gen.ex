defmodule ExchangeService.StockUpdateGenerator do
  use Agent

  import Util, only: :macros

  @type stock :: %{
    id:         atom(),
    value:      float(),
    volatility: integer()
  }

  @spec start_stock_updates(integer(), stock()) :: pid()
  def start_stock_updates(interval, stock) do
    spawn(__MODULE__, :send_stock_update, [interval, stock])
  end

  @spec calc_next_value(integer(), integer()) :: float()
  defp calc_next_value(_volatility, curr_value) do
    :rand.uniform(1)  # Generate a random number between [0;1]
    ~> 2*&1+1         # Scale it to [1;3]
    ~> :math.tan/1    # Calculate the factor between [0%;200%]
    ~> &1/45          #
    ~> :math.exp/1    # Map the factors to [~33%;~300%] to make the gains compensate for the losses
    ~> &1*curr_value  # Return the next value based on the current value
    ~> :math.ceil/1   # Round up the the nearest cent
    # # v = volatility / 1.5          # Create a volatility factor (nerfed by 1.5)
  end

  # @spec send_stock_update(integer, stock) :: no_return()
  def send_stock_update(interval, stock) do
    %{ # Destructure the stock type
      :id         => id,
      :value      => value,
      :volatility => volatility
    } = stock

    # Send an update with the new stock value to the parent process
    new_value = calc_next_value(value, volatility)
    send(self(), { :stock_update, id, new_value })

    # Wait the given interval and loop
    :timer.sleep(interval)
    send_stock_update(interval, stock)
  end
end
