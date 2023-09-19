defmodule Transport do
  def __using__(_opts) do
    quote do
      import Protobuf
      import Transport
    end
  end
end
