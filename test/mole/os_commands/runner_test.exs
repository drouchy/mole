defmodule CommandRunnerTest do
  use ExUnit.Case

  import Mole.OsCommands.Runner

  test "it returns a pid" do
    pid = run("ls -l")

    assert pid != nil
  end

  test "it launches a port & send back the result via a message" do
    run("ls -l")

    receive do
      { pid, { :data , data } } -> assert data != nil
    after
      5 -> raise "I guess we are not going to receive a message from the port"
    end
  end
end