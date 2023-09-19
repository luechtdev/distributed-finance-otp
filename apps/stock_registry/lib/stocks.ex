defmodule StockRegistry.Stocks do
  import StockRegistry.Macros

  @moduledoc """

    This module defines all stocks, that are used in this simulation.
    The stocks are defined by an identifier atom, a starting value in cents
    and a volatility value between 0 and 10, simulating different types of
    stock volatility.

  """

  # ----- | [ID] | [value] | [volatility 0..10]
  defstock :MSFT,   100_00, 10
  defstock :AAPL,   100_00, 2
  defstock :GOOGL,  100_00, 8
  defstock :FB,     120_00, 3
  defstock :AMZN,   150_00, 5
  defstock :TSLA,   200_00, 9
  defstock :NFLX,   120_00, 3
  defstock :NVDA,   100_00, 2
  defstock :PYPL,    80_00, 7
  defstock :BRKA,   300_00, 4
  defstock :V,      150_00, 8
  defstock :JPM,    120_00, 6
  defstock :KO,     100_00, 3
  defstock :WMT,     80_00, 2
  defstock :PG,     110_00, 5
  defstock :DIS,    100_00, 2
  defstock :NKE,    120_00, 3
  defstock :CRM,    150_00, 7
  defstock :COST,    80_00, 5
  defstock :BAC,    100_00, 8
  defstock :VZ,     110_00, 6
  defstock :ADS,     95_00, 3
  defstock :BAS,    110_00, 5
  defstock :BMW,    120_00, 7
  defstock :DAI,     90_00, 2
  defstock :DB1,    100_00, 3
  defstock :DPW,     80_00, 4
  defstock :DTE,    110_00, 6
  defstock :HEN3,    95_00, 2
  defstock :SAP,    130_00, 8
  defstock :VOW3,   115_00, 5
  defstock :FME,    105_00, 4
  defstock :FRA,     95_00, 2
  defstock :MRK,     98_00, 3
  defstock :MUV2,    82_00, 5
  defstock :RWE,     84_00, 4
  defstock :SZU,    118_00, 6
  defstock :TKA,     72_00, 7
  defstock :VNA,    109_00, 5
  defstock :WDI,    125_00, 8
  defstock :ZAL,    142_00, 9

  # This is the base case for all other identifiers or values
  defstock()

end
