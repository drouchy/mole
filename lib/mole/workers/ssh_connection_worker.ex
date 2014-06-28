defmodule Mole.Workers.SshConnectionWorker do
  use GenServer
  require Lager

  alias Mole.SshConnection

  def start_link() do
    Lager.debug "stating ssh connection link"
    :gen_server.start_link({:local, :mole_ssh}, __MODULE__, [], [])
  end

  def init() do
    {:ok, []}
  end

  def handle_call(_message, _from, state) do
  end

  def handle_cast({:execute, destination, command, callback}, state) do
    Lager.debug "handle_cast #{inspect(destination)}"
    host = destination[:host]
    port = destination[:port]
    Lager.debug "connecting"
    {connection, channel} = SshConnection.connect(to_char_list(host), port, options)
    name = "#{host}:#{port}"
    Lager.debug "executing command"
    pid = spawn(Mole.SshConnection, :execute_command, [{connection, channel}, to_char_list(command), callback])
    { :noreply, [%{name: name, pid: pid, host: host, port: port, ssh: {connection, channel}} | state] }
  end

  def handle_info(_msg, _state) do
  end

  def terminate(_reason, _state) do
  end

  def code_change(_old_vsn, _state, _extra) do
  end

  defp options do
    [ silently_accept_hosts: true, user_dir: to_char_list(config["ssh_dir"]), user: to_char_list(config["user"]) ]
  end

  defp config, do: Mole.config["global"]
end
