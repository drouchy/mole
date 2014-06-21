defmodule Mole.Workers.SshConnectionWorker do
  use GenServer

  import Mole.SshConnection

  def start_link() do
    :gen_server.start_link({:local, :mole_ssh}, __MODULE__, [], [])
  end

  def init() do
    {:ok, []}
  end

  def handle_call({:execute, destination, command, callback}, _from, state) do
    host = destination[:host]
    port = destination[:port]
    {connection, channel} = connect(to_char_list(host), port, options)
    name = "#{host}:#{port}"
    pid = spawn(Mole.SshConnection, :execute_command, [{connection, channel}, to_char_list(command), callback])
    { :reply, {:ok, name}, [%{name: name, pid: pid, host: host, port: port, ssh: {connection, channel}} | state] }
  end

  def handle_cast(_msg, _state) do
  end

  def handle_info(_msg, _state) do
  end

  def terminate(_reason, _state) do
  end

  def code_change(_old_vsn, _state, _extra) do
  end

  defp options do
    [ silently_accept_hosts: true, user_dir: '/Users/drouchy/.ssh/shutl', user: 'drouth' ]
  end
end
