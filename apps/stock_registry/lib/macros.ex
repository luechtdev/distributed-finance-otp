defmodule StockRegistry.Macros do

  # Exchanges:

  defmacro defexchange(id, stocks) do
    quote do
      def get_exchange(unquote(id)), do: {unquote(id), unquote(stocks)}
    end
  end

  defmacro expose_exchanges(amount) do
    max = amount - 1
    quote do
      def get_exchange(_), do: :undefined
      def all_exchanges do
        for i <- 0..unquote(max) do
          get_exchange i
        end
      end
    end
  end

  # Stocks:

  defmacro defstock(id, default_value, volatility) do
    quote do
      def get_stock(unquote(id)) do
        [
          unquote(id),
          default_value: unquote(default_value),
          volatility: unquote(volatility)
        ]
      end
    end
  end

  defmacro defstock do
    quote do
      def get_stock(_), do: :undefined
    end
  end

  # Portfolios:

  defmacro defportfolio(id, name, ownerships) do
    quote do
      def get_portfolio(unquote(id)) do
        {unquote(name), unquote(ownerships)}
      end
    end
  end

  defmacro expose_portfolios(amount) do
    max = amount - 1
    quote do
      def get_portfolio(_), do: :undefined
      def all_portfolios do
        for i <- 0..unquote(max) do
          get_portfolio i
        end
      end
    end
  end

end
