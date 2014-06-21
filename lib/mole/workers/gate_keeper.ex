defmodule Mole.Workers.GateKeeper do
  use GenServer

  import Mole.OsCommands.Runner
  import Mole.OsCommands.GateCommand

  def start_link() do
    :gen_server.start_link({:local, :mole_gate_keeper}, __MODULE__, [], [])
  end

  def init(options) do
    default = [port: 2000, connections: []]
    { :ok, Keyword.merge(default, options) }
  end

  def handle_call({:open_gate, destination}, _from, state) do
    {port, new_state } = case opened_connection(state, destination) do
      nil        -> open_new_connection(state, destination)
      connection -> reuse_connection(state, connection)
    end

    {:reply, {:ok, port}, new_state}
  end

  def handle_cast(_msg, _state) do
  end

  def handle_info(_msg, _state) do
  end

  def terminate(_reason,  _state) do
    IO.puts "terminate"
  end

  def code_change(_old_vsn, _state, _extra) do
  end

  defp increase_port(options) do
    Keyword.put(options, :port, options[:port]+1)
  end

  defp open_gate(state, destination) do
    pid = gate_command(state, destination) |> run
    { state , pid }
  end

  defp register_connection({ state, pid }, destination) do
    connection = connection_description(state, destination, pid)
    Keyword.put(state, :connections, [connection|state[:connections]])
  end

  defp connection_description(state, destination, pid) do
    %{
      local_host: "localhost",
      local_port: state[:port],
      host: destination[:host],
      port: 22,
      environment: destination[:environment],
      service: destination[:service],
      pid: pid
    }
  end

  # test that part. I don't know yet how to add multiple mocks - may be extract all the logic in a dedicated module
  defp gate_command(state, destination) do
    options = %{gateway: destination[:gateway], host: destination[:host], port: state[:port], user_dir: config["ssh_dir"], user: config["user"]}
    open_gate_command(options)
  end

  defp config, do: Mole.config["global"]

  defp opened_connection(state, destination) do
    Enum.find(state[:connections], fn(connection) -> equal?(destination, connection) end)
  end

  defp equal?(destination, connection) do
    destination[:environment] == connection[:environment] && destination[:host] == connection[:host] && destination[:port] == connection[:port]
  end

  defp open_new_connection(state, destination) do
    new_state = state
      |> open_gate(destination)
      |> register_connection(destination)
      |> increase_port

    { state[:port], new_state }
  end

  defp reuse_connection(state, connection) do
    { connection[:local_port], state }
  end
end
