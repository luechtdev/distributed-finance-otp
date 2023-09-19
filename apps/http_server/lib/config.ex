defmodule HttpServer.Config do

  @moduledoc """

  """

  @type methods :: :get
    | :post
    | :put
    | :patch
    | :delete
    | :options
    | :head
    | :trace

  defstruct app_name: "Generic",
    version: "v1.0",
    httpv: 1.0,
    port: 8000,
    methods: [:get, :post, :patch, :delete, :options, :head]

  @type t :: %__MODULE__{
    :app_name => String.t(),
    :version  => String.t(),
    :httpv    => float(),
    :port     => number(),
    :methods  => [methods()]
  }

end
