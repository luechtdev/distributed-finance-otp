defmodule BankService do
  use GenServer

  @moduledoc """

    On the top most level - the bank service is represented as a state
    maschine. A bank can either be healthy, bankrupt or rescued
    The bank service keeps track of this state via the GenServer as a simple atom.

  """

  @type state :: :init | :healthy | :bankrupt | :rescued

  def init(:ok) do
    {:ok, :healthy}
  end

  # Calls are used to transition the state of the state maschine
  @spec handle_call(any(), pid(), state()) :: {:reply, :ok | :invalid_state, state()}

  # Transition into the bankrupt state (only when healthy)
  def handle_call(:announce_bankrupt, _from, :healthy), do: {:reply, :ok, :bankrupt}
  def handle_call(:announce_bankrupt, _from, state), do: {:reply, :invalid_state, state}

  # Transition into the rescued state (only when bankrupt)
  def handle_call(:announce_rescued, _from, :bankrupt), do: {:reply, :ok, :rescued}
  def handle_call(:announce_rescued, _from, state), do: {:reply, :invalid_state, state}

  # Transition back to the normal state after recovery (only when rescued)
  def handle_call(:announce_recovered, _from, :bankrupt), do: {:reply, :ok, :healthy}
  def handle_call(:announce_recovered, _from, state), do: {:reply, :invalid_state, state}

end
