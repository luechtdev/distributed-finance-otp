defmodule HttpServer.Headers do

  @moduledoc """
    This module wraps the map of headers, both for request
    and response. It mostly delegates the functionality to
    a normal Map but includes functionality for encoding
    or for adding generated headers.
  """

  use Timex

  @behaviour Map
  @type t :: %{(String.t() | atom()) => String.t()}

  defdelegate put(headers, key),  to: Map
  defdelegate get(headers, key),  to: Map
  defdelegate has?(headers, key), to: Map, as: :has_key

  @doc """
    A valid HTTP Response requires a Date header in the RFC1123 format.
    This function adds that header to the provided header map.
  """
  @spec put_rfc1123_date(t()) :: t()
  def put_rfc1123_date(headers) do
    # Format into RFC1123
    {:ok, date_rfc1123} = Timex.now("Europe/London") |> Timex.format("{RFC1123}")

    # Add the date to the `Date` header
    Map.put headers, "Date", date_rfc1123
  end

  @doc """
    Encode the headers into a string.
    Each key-value pair is parsed into the `key=value`
    format before being joined by newlines as of HTTP
    Specification.
  """
  @spec encode(t()) :: String.t()
  def encode(headers) do
    Map.to_list headers
    |> Enum.map(&Enum.join(&1, ":"))
    |> Enum.join("\n")
  end

end
