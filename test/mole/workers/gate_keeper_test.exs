defmodule GateKeeperTest do
  use ExUnit.Case
  import Mock

  import Mole.Workers.GateKeeper

  setup _context do
    :gen_server.call :mole_config, { :reload, config_file }
    :ok
  end

  # init/1
  test "returns :ok with the options" do
    options = [option_1: true]

    { :ok, [option_1: true, port: 2000, connections: []] } = init(options)
  end

  test "the port can be set in the options" do
    options = [port: 2200, option_1: true]

    { :ok, new_options} = init(options)
    assert new_options[:port] == 2200
  end

  # handle_call/3 -> open_gate
  test_with_mock "it increases the current port", Mole.OsCommands.Runner, [run: mock_run_command] do
    options = [port: 2010, option_1: true, connections: []]

    {:reply, {:ok, 2010}, new_state} = handle_call({:open_gate, destination}, self, options)

    assert new_state[:port] == 2011
  end

  test_with_mock "it registers the new connection", Mole.OsCommands.Runner, [run: mock_run_command] do
    options = [port: 2010, option_1: true, connections: []]

    {:reply, {:ok, 2010}, new_state} = handle_call({:open_gate, destination}, self, options)

    connection = List.first new_state[:connections]
    assert connection == expected_connection
  end

  defp config_file,       do: "test/fixtures/config/regular.json"
  defp destination,       do: [environment: "staging", service: "log_service", host: "host1.example.com", gateway: "gateway.example.com", port: 22]
  defp mock_run_command,  do: fn(_) -> "pid" end

  defp expected_connection do
    %{
      local_host: "localhost",
      local_port: 2010,
      host: "host1.example.com",
      port: 22,
      environment: "staging",
      service: "log_service",
      pid: "pid"
    }
  end
end