defmodule Mole.ServiceLogger do
  require Lager

  def log_service(args) do
    Lager.info "log service: #{inspect(args)}"
    service     = :gen_server.call :mole_config, {:service, args[:environment], args[:service]}
    environment = :gen_server.call :mole_config, {:environment, args[:environment]}
    gateway = environment["gateway"]

    destinations = generate_destinations(Map.put(args, :gateway, gateway), service["hosts"], [])

    tunneled = Enum.map(destinations, &open_gate/1)

    Mole.Loading.load_for("Connecting", 2000)

    tunneled
    |> enrich_destination_with_logs(service["logs"])
    |> Enum.with_index
    |> Enum.map(fn({destination,index}) -> Map.put(destination, :color, Mole.ANSI.color(index)) end)
    |> Enum.each(&launch_connection/1)
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
    command = "tail -F #{destination[:log]["file"]}\n"
    Lager.info "launch connection to #{destination[:local_host]}:#{destination[:local_port]}"
    :gen_server.cast :mole_ssh, {:execute, %{host: destination[:local_host], port: destination[:local_port]}, command, fn(data) -> callback(destination, data) end}
  end

  defp callback(_, []), do: :done
  defp callback(destination, [line|tail]) do
    :gen_server.cast :mole_console, {:write, %{color: destination[:color], text: destination[:host]}, line }
    callback(destination, tail)
  end

  defp enrich_destination_with_logs(destinations, logs) do
    enrich_destination_with_logs [], destinations, logs
  end
  defp enrich_destination_with_logs(acc, [], _), do: acc
  defp enrich_destination_with_logs(acc, [destination|tail], logs) do
    enrich_destination_with_logs(acc ++ logs_for_destination(destination, logs), tail, logs)
  end

  defp logs_for_destination(destination, logs) do
    logs
    |> Enum.map fn(log_file) -> Map.put(destination, :log, log_file) end
  end
end
