defmodule Mole.ServiceLogger do
  def log_service(args) do
    service     = :gen_server.call :mole_config, {:service, args[:environment], args[:service]}
    environment = :gen_server.call :mole_config, {:environment, args[:environment]}
    gateway = environment["gateway"]

    destinations = generate_destinations(Map.put(args, :gateway, gateway), service["hosts"], [])

    tunneled = Enum.map(destinations, &open_gate/1)

    Mole.Loading.load_for("Connecting", 2000)

    tunneled = Enum.with_index(tunneled)
      |> Enum.map(fn({destination,index}) -> Map.put(destination, :color, Mole.ANSI.color(index)) end)
      |> Enum.map(fn(destination) -> Map.put(destination, :log, service["logs"]) end)

    Enum.each(tunneled, &launch_connection/1)
  end

  defp generate_destinations(_args, [], transformations), do: transformations
  defp generate_destinations(args, [host|tail], transformations) do
    destination = %{environment: args[:environment], service: args[:service], host: host, port: 22, gateway: args[:gateway]}
    generate_destinations(args, tail, [destination|transformations])
  end

  defp open_gate(destination) do
    {:ok, port} = :gen_server.call :mole_gate_keeper, {:open_gate, destination}
    destination
      |> Map.put(:local_port, port)
      |> Map.put(:local_host, "localhost")
  end

  defp launch_connection(destination) do
    command = "tail -f #{destination[:log]}\n"
    :gen_server.call :mole_ssh, {:execute, %{host: destination[:local_host], port: destination[:local_port]}, command, fn(data) -> callback(destination, data) end}
  end

  defp callback(_, []), do: :done
  defp callback(destination, [line|tail]) do
    :gen_server.cast :mole_console, {:write, %{color: destination[:color], text: destination[:host]}, line }
    callback(destination, tail)
  end
end
