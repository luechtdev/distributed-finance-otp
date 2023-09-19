defmodule ExchangeService.Application do
  use Application

  @moduledoc """
    This application serves the function of a stock exchange.
    It manages its own portfolio of stocks, generates updates
    and sends them via a UDP multicast packet to all subscribed
    banks.

    The UpdateGenerator will send updates in the form of messages
    into the message queue of the current module.
  """

  alias ExchangeService.StockUpdateSupervisor
  alias ExchangeService.Portfolio
  alias ExchangeService.StockUpdateGenerator
  alias ExchangeService.UDPService

  @impl true
  def start(_type, _args) do
    :logger.info "Starting the ExchangeService @", Node.self

    # Initialize an empty portfolio state
    {:ok, portfolio} = Portfolio.init

    # Start the stock updates and listen to the messages
    StockUpdateSupervisor.start_link portfolio
    receive_messages portfolio
  end

  defp receive_messages(portfolio) do
    receive do

      # If a new stock update is generated
      # Log a message to the console, distribute the
      # message and recurse back.
      {:stock_update, id, value} ->
        updated = Portfolio.update(portfolio, id, value)
        UDPService.send_update(id, value, updated)
        receive_messages(portfolio)

      # If the value of a specific stock is requested
      # Send the value to the provided socket.
      {:request_value, socket, id} ->
        Portfolio.get(portfolio, id)
        :logger.emergency "Unimplemented!"
        receive_messages(portfolio)

      _ ->
        :logger.warning "Recieved unknown message"
        receive_messages(portfolio)

    after
      10_000 ->
        :logger.warning("Haven't recieved stock update in 10 seconds...")
        receive_messages(portfolio)
    end
  end

end
