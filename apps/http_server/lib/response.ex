defmodule HttpServer.Response do

  alias HttpServer.Headers
  alias HttpServer.ResponseDefaults

  @moduledoc """
    This module wraps the HTTP-Response, that will be used inside the
    HttpServer.handle_request/3 function to contain all informations, that
    will be returned to the client.
  """

  defstruct status: 200,
    http_version: "HTTP 1.0",
    body: nil,
    headers: %{}

  @type t :: %__MODULE__{
    status: integer(),
    http_version: String.t(),
    body: any(),
    headers: Headers.t()
  }

  ### Default responses ####

  @doc """
    The `default` response is provided to the HttpServer.handle_request/3
    function and shall be returned for it to be sent by the server.

    This function inherits the default values defined above by default
    but can be overwritten to include headers or HTTP Versions on every
    request, that is handled by the server.
  """
  @callback default() :: t()
  def default, do: %__MODULE__{}

  @doc """
    The `not_found` response is returned to the client, if no matching
    handle_request/3 function was implemented.
  """
  @callback not_found() :: t()
  def not_found, do: %__MODULE__{ status: 404 }

  @doc """
    The `internal_error` reponse is retured to the client, if an error
    ocurred during the handling of the request. It can be overwritten by
    the implementation.
  """
  @callback internal_error() :: t()
  def internal_error, do: %__MODULE__{ status: 500 }

  #### Text encoding ####

  defp encode_resp_line(%__MODULE__{http_version: version, status: status}) do
    # httpc = case  do
    #    ->

    # end
  end

  @spec encode(t()) :: String.t()
  def encode(response) do

  end

end
