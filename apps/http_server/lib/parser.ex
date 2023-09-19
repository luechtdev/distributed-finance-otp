defmodule HttpServer.Parser do

  alias HttpServer.Request

  defp supported_versions(v) do
    case v do
      "HTTP/1.0"  -> {:supported, 1.0}
      "HTTP/1.1"  -> {:supported, 1.1}
      "HTTP/2"    -> {:supported, 2.0}
      "HTTP/3"    -> {:supported, 3.0}
      _           -> {:not_supported}
    end
  end

  defp supports_version?(version) do
    case supported_versions(version) do
      {:not_supported} -> false
      _ -> true
    end
  end

  defp supported_methods(m) do
    case m do
      "GET"     -> {:supported, :get}
      "PUT"     -> {:supported, :put}
      "POST"    -> {:supported, :post}
      "PATCH"   -> {:supported, :patch}
      "DELETE"  -> {:supported, :delete}

      # The implementation of OPTIONS and HEAD are
      # internally handled by the http server and
      # not the implementation.
      "OPTIONS" -> {:internal, :options}
      "HEAD"    -> {:internal, :head}
      _         -> :not_supported
    end
  end
  # defp supports_method?(verb) when supported_methods(verb) == :supported, do: true
  defp supports_method_int?(verb), do: supported_methods(verb) != :not_supported

  @request_header_pattern ~r/(?<key>[\w-]+): (?<value>)/
  defp parse_request_header(line) do
    case Regex.named_captures @request_header_pattern, line do
      %{"key" => key, "value" => value} -> {:ok, {key, value}}
      nil -> {:error, "Invalid request header syntax"}
    end
  end

  # @spec assign_request_header({:reject, String.t()}, any()) :: {:reject, String.t()}
  # @spec assign_request_header({:accept, Request.t()}, [Request.t()] | Request.t)
  defp assign_request_header({:reject, reason }, _),  do: {:reject, reason}
  defp assign_request_header({:accept, req}, []),     do: {:accept, req}
  defp assign_request_header({:accept, req}, [header | rest]) do
    case parse_request_header header do
      {:ok, key, value} -> assign_request_header({:accept, Request.addHeader(req, {key, value})}, rest)
      {:error, reason}  -> {:reject, reason}
    end
  end

  defp assign_request_body({:reject, reason}, _), do: {:reject, reason}
  defp assign_request_body({:accept, req}, body) do
    case Request.get_header req, "Content-Type" do
      nil ->  {:accept, Request.set_body(req, {:empty})}
      type -> {:accept, Request.set_body(req, BodyParser.parse(body, type))}
    end
  end


end
