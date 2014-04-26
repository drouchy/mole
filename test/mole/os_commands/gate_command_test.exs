defmodule GateCommandTest do
  use ExUnit.Case

  import Mole.OsCommands.GateCommand

  test "generates a basic ssh command with a local tunnel" do
    details = [gateway: gateway, host: to, port: 2222]

    command = open_gate_command(details)

    assert command == "ssh #{gateway} -L 2222:#{to}:22 -N"
  end

  test "can give an option for the identity" do
    details = [gateway: gateway, host: to, port: 2222, user_dir: '/var/tmp/ssh']

    command = open_gate_command(details)

    assert command == "ssh #{gateway} -i /var/tmp/ssh/id_rsa -L 2222:#{to}:22 -N"
  end

  test "does not include the indentity if present but nil" do
    details = [gateway: gateway, host: to, port: 2222, user_dir: nil]

    command = open_gate_command(details)

    assert command == "ssh #{gateway} -L 2222:#{to}:22 -N"
  end

  test "can give a user as an option" do
    details = [gateway: gateway, host: to, port: 2222, user: 'testUser']

    command = open_gate_command(details)

    assert command == "ssh testUser@#{gateway} -L 2222:#{to}:22 -N"
  end

  test "does not include the user if present but nil" do
    details = [gateway: gateway, host: to, port: 2222, user: nil]

    command = open_gate_command(details)

    assert command == "ssh #{gateway} -L 2222:#{to}:22 -N"
  end

  defp gateway, do: "gateway.example.com"
  defp to,   do: "to.example.com"
end