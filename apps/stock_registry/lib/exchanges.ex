defmodule StockRegistry.Exchanges do
  import StockRegistry.Macros

  @moduledoc """

    This module defines all exchanges, that dictate the prices
    of the individual stocks they control.
    The module exposes an `get_exchange/1` and the `all_exchanges/0`
    methods to access the exchanges defined below

  """

  defexchange 0,  [:AAPL, :GOOGL, :MSFT]
  defexchange 1,  [:FB, :AMZN, :TSLA]
  defexchange 2,  [:NFLX, :NVDA, :PYPL, :BRKA, :V]
  defexchange 3,  [:JPM, :KO]
  defexchange 4,  [:WMT, :PG, :DIS]
  defexchange 5,  [:NKE, :CRM]
  defexchange 6,  [:COST, :BAC]
  defexchange 7,  [:VZ, :PG]
  defexchange 8,  [:ADS, :BAS, :BMW, :DAI]
  defexchange 9,  [:DB1, :DPW, :DTE]
  defexchange 10, [:HEN3, :SAP, :VOW3, :FME]
  defexchange 11, [:FRA, :MRK, :MUV2, :RWE, :SZU]
  defexchange 12, [:TKA, :VNA]
  defexchange 13, [:WDI, :ZAL]

  # Expose all 14 exchanges and include a base-case
  # for all other identifiers
  expose_exchanges 14

end
