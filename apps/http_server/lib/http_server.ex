defmodule HttpServer do

  use GenServer

  alias HttpServer.Config
  alias HttpServer.Parser
  alias HttpServer.Route
  alias HttpServer.ResponseDefaults
  alias HttpServer.Request
  alias HttpServer.Response

  @moduledoc """

    This module implements a HTTP server that can be used by
    any application.

    The usage of this module can be customized using the following keywords:
    - :app_name -> The name of the application (include in the `Server` header)
    - :version  -> The current version of the application
    - :httpv    -> The supported HTTP Version
    - :port     -> The port that the socket listens on

  """

  def init(:ok), do: {:ok, %Config{}}

  defmacro __using__(opts) do

    # Extract the options from the usage or use default values
    app_name      = Keyword.get opts, :app_name,  "Generic"
    version       = Keyword.get opts, :version,   "v1"
    methods       = Keyword.get opts, :methods,   [:get, :post, :patch, :delete, :options, :head]
    http_version  = Keyword.get opts, :httpv,     1.0
    port          = Keyword.get opts, :port,      8000

    quote do
      @impl true
      def init(:ok) do
        pid = spawn_link __MODULE__, :start, [unquote(port)]
        {:ok, %Config{
          app_name: unquote(app_name),
          version:  unquote(version),
          httpv:    unquote(http_version),
          port:     unquote(port),
          methods:  unquote(methods)
        }}
      end
    end
  end

  # @callback response_defaults() :: ResponseDefaults
  # def response_defaults, do: Response.Defaults

  # The individual routes shall be defined by the implementation
  # of the http server regarding the following function signature.
  @callback handle_request({ atom(), Route.t() }, Request.t(), Response.t()) :: Response.t()

  # A default shall be provided for all other routes, returning
  # the default `not_found` response.
  def handle_request({ _method, _route }, _request, _reponse), do: Response.not_found

  def handle_cast({:request, req}, state) do

  end


  defp accept_request(socket) do

    # Get the content of the request
    content = IO.gets socket, ""
    request = Request.decode content

    # Call the
    # %Request{"method" => method, "path" => path } = request
    # handle_request { method, path }, request, Response.default

    :gen_tcp.close(socket)
  end

  # defp send_response(socket, response) do
  #   :gen_tcp.send socket, response
  #   :gen_tcp.close socket
  # end

  def start(port) do
    {:ok, listen_socket} = :gen_tcp.listen port, [:binary, active: true]
    :logger.info "HTTP server listening on port #{port}"
    accept_connections listen_socket
  end

  defp accept_connections(listen_socket) do
    case :gen_tcp.accept(listen_socket) do
      {:ok, client_socket} ->
        # On a socket connection, spawn a new concurrent process
        # running the accept_request/1 method and pass the client
        # socket to the new process.
        pid = spawn __MODULE__, :accept_request, client_socket
        :logger.info "Accept client request on process #{pid}"

        # Recurse back, to be ready for the next connection
        accept_connections listen_socket

      err -> err
    end
  end
end
