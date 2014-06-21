defmodule Mole.SshConnection do

  def send_command(host, port, options, command, callback) do
    {connection, channel} = connect(host, port, options)
    execute_command({connection, channel}, command, callback)
  end

  def connect(host, port, options) do
    :crypto.start
    :ssh.start
    {:ok, connection} = :ssh.connect(host, port, options)
    {:ok, channel} = :ssh_connection.session_channel(connection, 1000)

    {connection, channel}
  end

  def execute_command({connection, channel}, command, callback) do
    :ssh_connection.shell(connection, channel)
    :ok = :ssh_connection.send(connection, channel, command, 2000)
    ssh_loop(connection, channel, callback)
  end

  defp ssh_loop(_connection, channel, callback) do
    receive do
      {:ssh_cm, connection, {:data, _channel, 0, data}} ->
        callback.(String.split(String.strip(data), "\n"))
        ssh_loop(connection, channel, callback)
      other -> IO.puts "received something I did not understand #{inspect other}"
    end
  end
end
