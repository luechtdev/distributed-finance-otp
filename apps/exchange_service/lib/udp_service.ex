defmodule ExchangeService.UDPService do
  @moduledoc """
    This module is used to distribute the stock updates
    via UDP packages. The configuration of the socket is
    done on the `init` method and is kept in the state of
    the GenServer. The used socket is kept open as long as
    the process is running.
  """

  use GenServer

  alias Transport.StockUpdate
  import Util, only: :macros

  @multicast_ip Application.compile_env :exchange_service, :udp_multicast_ip, {234, 0, 0, 1}

  defp apply_channel({i1,i2,i3,i4}, ch), do: {i1,i2,i3,i4+ch}

  def init(channel) do
    # When the UDP Service is started, open the socket on port 0
    # and set the options to allow for IP-Multicast.
    # The socket is defines the state of this GenServer and will
    # be available for all casts and calls.
    {:ok, socket} =:gen_udp.open 0, [
      :binary,
      reuseaddr: true,
      ip: apply_channel(@multicast_ip, channel),
      ttl: 10
    ]
    :inet.setopts socket, [
      broadcast: true,
      multicast_if: {0,0,0,0},
      reuseaddr: true
    ]
    {:ok, socket}
  end

  @doc """
    On any termination of the process, close the socket (state)
  """
  def terminate(_reason, udp_socket) do
    :gen_udp.close udp_socket
  end

  @doc """
    All published updates from this exchange are transmitted to the
    UDP process via a async cast. This way the UDP process can keep
    its state, configuration and socket open.
    This way, we dont need to pass the configuration of port and ip
    everytime we send a message.
  """
  def handle_cast({:send_update, id, value, created}, udp_socket) do
    # Assert that the encoding is sucessful and only send valid messages
    with {:ok, data} <- encode_update id, value, created  do
      :gen_udp.send udp_socket, data
    end

    # The new state is unchanged
    {:noreply, udp_socket}
  end

  defp encode_update(id, value, created) do
    try do
      # The updates are encoded via the protobuf
      # definition from the Transport module imported
      # above.
      %StockUpdate{
        id: id,
        value: value,
        time_created: created,
        time_encoded: System.os_time
      }

      # The message is encoded into iodata for the socket
      # and wrapped into a tuple with the :ok status
      |> Protobuf.encode_to_iodata()
      ~> {:ok, &1}

    rescue
        # Since the encoding can possibly throw an error, the error
        # is recued and printed to the console. An :error status is returned.
        Protobuf.EncodeError ->
          :logger.error "Could not encode `StockUpdate`!"
          :logger.error Exception.format :error, Protobuf.EncodeError, __STACKTRACE__
          {:error}
    end
  end
end
