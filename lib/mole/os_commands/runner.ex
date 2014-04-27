defmodule Mole.OsCommands.Runner do
  def run(command) do
    pid = Port.open({:spawn, command}, [:binary, :exit_status])
  end
end