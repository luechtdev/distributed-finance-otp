defmodule HttpServer.Request do

  alias HttpServer.Headers

  defstruct method: :get,
    path: "/",
    headers: %{},
    body: nil,
    http_version: 1

  @type t :: %__MODULE__{
    method: atom(),
    path: String.t(),
    headers: Headers.t(),
    http_version: float()
  }

  # Annotation for a CRLF constant represented by binary charcode
  @crlf <<13,10>>

  @spec decode(String.t()) :: t()
  def decode(request) do
    # The head and body parts of the HTTP request are seperated
    # by a double `CRLF` sequence. The `parts: 2` annotation
    # makes sure that the body isn't split and any further.
    # The head can be splitted into the requestline(reql)
    # and the headers(headr) as a list
    [head | body ] = String.split request, @crlf <> @crlf, parts: 2
    [reql | headr] = String.split head, @crlf

    # Create the request and assign parse all parts of the request into the struct
    # The first part of the tuple is used to pass errors down the pipe, by default
    # there is no error and the request is accepted
    parsed = {:accept, %Request{}}
    |> decode_pipe(&decode_request_line/1, reql)
    |> decode_request_line(reql)
    |> assign_request_header(headr)
    |> assign_request_body(body)

    with {:accept, req} <- parsed do

    else
      {:reject, reason} ->
        :logger.warning "Malformed HTTP got rejected. Reason: `#{reason}`"
    end
  end

  # As seen above in decode/1 we use this function to pipe
  # the request through all the decoding steps.
  # To catch any malformed request, the request is coupled with
  # a :accept or :reject atom to label invalid request.
  # The decode_pipe/3 method passes rejected request without any further parsing.
  defp decode_pipe(prev, fun, arg) do
    with {:accept, req} <- prev do
      # If the request is valid until this point execute the next step
      case fun.(arg) do
        {:ok, req} -> {:accept, req}
        {:error, err} -> {:reject, err}
      end
    else
      # Pass on every already rejected request
      {:reject, reason} -> {:reject, reason}
    end
  end

  @request_line_pattern ~r/^(?<method>[A-Z]+) (?<path>.+?) (?<version>HTTP\/3|2|1\.[01])(?:\s*)\r\n/
  defp decode_request_line(line) do
    case Regex.named_captures @request_line_pattern, line do

      # If all three groups are captured, validate the support and return :ok
      %{"method" => method, "path" => path, "version" => version} ->
        cond do
          not supports_version?   version -> {:error, {:version_not_unsupported, "HTTP Version not supported"}}
          not supports_method_int? method -> {:error, {:method_not_supported, "HTTP Method not supported"}}
          true                            -> {:ok, method, path, version}
        end

      # For all other cases return an error
      _ -> {:error, "No valid request line format."}
    end
  end

  defp assign_request_line({:reject, reason}, _), do: {:reject, reason}
  defp assign_request_line({:accept, request}, line) do
    with {:ok, method, path, version} <- parse_request_line line do
      {:accept, %Request{request | method: method, path: path, http_version: version}}
    else
      {:error, _} -> {:reject, "Invalid request line"}
    end
  end

  #### Functions related to the header map ####

  @spec add_header(t(), {String.t(), String.t()}) :: t()
  def add_header(req, {key, value}), do: %__MODULE__{req | headers: Headers.add(req.headers, {key, value})}

  @spec get_header(t(), String.t()) :: String.t()
  def get_header(req, key), do: Headers.get(req.headers, key)

  @spec has_header?(t(), String.t()) :: boolean()
  def has_header?(req, key), do: Headers.has?(req.headers, key)

  #### Functions related to the request body ####

  @spec set_body(t(), any()) :: t()
  def set_body(req, body), do: %__MODULE__{req | body: body}

end
