defmodule BodyParser do
  @spec decode(binary(), String.t()) :: {atom(), any()}
  @spec encode(atom(), any()) :: {binary(), String.t()}

  # Add parsing implementation for the protobuf messages defined in the `Transport` library
  import Transport
  def decode(body, "application/protobuf;proto=dsf.StockUpdate"),  do: {:pb_stock, Protobuf.decode(Transport.StockUpdate, body)}
  def decode(body, "application/protobuf;proto=dsf.Portfolio"),    do: {:pb_portf, Protobuf.decode(Transport.Portfolio)}

  def encode({:pb_stock, struct}), do: {Protobuf.encode(body), "application/protobuf;proto=dsf.StockUpdate"}
  def encode({:pb_portf, struct}), do: {Protobuf.encode(body), "application/protobuf;proto=dsf.Portfolio"}

  # Add parsing implementation for JSON format via the `Jason` parser
  import JasonV
  def decode(body, "application/json"), do: {:json, JasonV.decode(body)}
  def encode({:json, struct}), do: {JasonV.encode(struct), "application/json"}

  # Add plain text support
  def decode(body, "plain/text"), do: {:text, to_string(body)}

  def decode(body, _), do: {:error, "Content-Type not supported"}
  def encode({_type, _struct}), do: {:error}

end
