defmodule StockRegistry.Portfolios do
  import StockRegistry.Macros

  @moduledoc """

    This module contains all definitions of the bank portfolios,
    each bank can own any amount of any share, that is managed by
    one of the exchanges.

    The list below describes the portfolios (banks) by
    - an id (priority - nodes will always be assigned the lowest free portfolio)
    - an alias (the name of the bank)
    - a list of all ownerships (as tuples of stock_id and quantity)

    This module exposes the `get_portfolio/1` and the `all_portfolios/0`
    methods to access the portfolios defined below.

  """

  # Type of the portfolios and callback, to be defined by the macros
  @type t :: {String.t(), [{atom(), number()}]}
  @callback get_portfolios(number) :: t()

  @id_range 0..9
  defportfolio 0, "Liliput Bank",  [AAPL: 20, AMZN: 10, PYPL: 30]
  defportfolio 1, "Bank 1 alias",  [TSLA: 24, NFLX: 31, AMZN: 10]
  defportfolio 2, "Bank 2 alias",  [NKE: 50, COST: 5, AAPL: 44]
  defportfolio 3, "Bank 3 alias",  [SAP: 15, FME: 15]
  defportfolio 4, "Bank 4 alias",  [HEN3: 5, AMZN: 5, MSFT: 10, GOOGL: 7]
  defportfolio 5, "Bank 5 alias",  [KO: 15, PG: 10, FME: 7]
  defportfolio 6, "Bank 6 alias",  [VZ: 10, DPW: 9, WDI: 10]
  defportfolio 7, "Bank 7 alias",  [NVDA: 8, HEN3: 2, AMZN: 10]
  defportfolio 8, "Bank 8 alias",  [ZAL: 19, PYPL: 5]
  defportfolio 9, "Bank 9 alias",  [COST: 7, SAP: 6]

  @doc """
    Registers an unassigned portfolio to the registry and returns
    it to the client.
  """
  @spec register(atom(), pid()) :: {:ok, t()} | {:error, any()}
  def register(reg, from) do
    # First check all portfolios in the registry.
    # This way, dead processes are already removed and not taken into account
    # Unassigned portfolios should return an empty list of connections
    unassigned_portfolios = @id_range
    |> Enum.take_while(fn i -> Enum.empty?(Registry.lookup reg, i) end)

    # Assert that at least one portfolio is unassigned.
    # As a small trick - if we append a random element, we can treat all lists
    # with only one element as an empty list in the match clause below
    with [portf, _rest] <- unassigned_portfolios ++ [:eol] do
      # Register the portfolio with the registry
      Registry.register reg, portf, from
      {:ok, get_portfolio portf}
    else
      # If all predefined portfolios are used, return an error
      [:eol] -> {:error, "All predefined portfolios are assigned"}
    end
  end

end
