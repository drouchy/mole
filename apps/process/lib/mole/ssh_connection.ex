defmodule Mole.SshConnection do
  require Lager

  @max_packet_size 999999999

  def send_command(host, port, options, command, callback) do
    IO.puts "connecting to #{host}:#{port}"
    {connection, channel} = connect(host, port, options)
    IO.puts "executing command #{command}"
    execute_command({connection, channel}, command, callback)
  end

  def connect(host, port, options) do
    Lager.debug "connecting to #{host}:#{port}"
    IO.inspect options
    :crypto.start
    :ssh.start
    {:ok, connection} = :ssh.connect(host, port, options)
    {:ok, channel} = :ssh_connection.session_channel(connection, @max_packet_size, @max_packet_size, 1000)

    {connection, channel}
  end

  def execute_command({connection, channel}, command, callback) do
    Lager.debug "executing command #{command}"
    :ssh_connection.shell(connection, channel)
    :ok = :ssh_connection.send(connection, channel, command, :infinity)
    ssh_loop(connection, channel, callback)
  end

  defp ssh_loop(_connection, channel, callback) do
    receive do
      {:ssh_cm, connection, {:data, _channel, 0, data}} ->
        callback.(String.split(String.strip(data), "\n"))
        ssh_loop(connection, channel, callback)
      other -> Lager.error "received something I did not understand #{inspect other}"
    end
  end
end
