defmodule ExchangeService.Stock do

  @moduledoc """

  """

  defstruct id: nil, value: 0, volatility: 0

  @type t :: %__MODULE__{
    id:         atom(),
    value:      float(),
    volatility: integer()
  }

end
