defmodule Mole.Workers.ConsoleWorker do
  use GenServer.Behaviour

  import Mole.ConsoleWriter

  def start_link() do
    :gen_server.start_link({:local, :mole_console}, __MODULE__, [], [])
  end

  def init() do
    { :ok, nil }
  end

  def handle_call(_msg, _from, _state) do
  end

  def handle_cast({:write, data}, state) do
    write(data)
    {:noreply, state}
  end

  def handle_cast({:write, prefix, data}, state) do
    write(prefix, data)
    {:noreply, state}
  end

  def handle_info(_msg, _state) do
  end

  def terminate(_reason, _state) do
  end

  def code_change(_old_vsn, _state, _extra) do
  end
end