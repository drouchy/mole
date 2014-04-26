defmodule GateCommandTest do
  use ExUnit.Case

  import Mole.OsCommands.GateCommand

  test "generates a basic ssh command with a local tunnel" do
    options = [port: 2222]

    command = open_gate_command(options, from, to)

    assert command == "ssh #{from} -L 2222:#{to}:22 -N"
  end

  test "can give an option for the identity" do
    options = [port: 2222, user_dir: '/var/tmp/ssh']

    command = open_gate_command(options, from, to)

    assert command == "ssh #{from} -i /var/tmp/ssh/id_rsa -L 2222:#{to}:22 -N"
  end

  test "can give a user as an option" do
    options = [port: 2222, user: 'testUser']

    command = open_gate_command(options, from, to)

    assert command == "ssh testUser@#{from} -L 2222:#{to}:22 -N"
  end

  defp from, do: "from.example.com"
  defp to,   do: "to.example.com"
end