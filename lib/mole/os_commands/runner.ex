defmodule Mole.OsCommands.Runner do
  def run(command) do
    pid = Port.open({:spawn, command}, [])
  end
end