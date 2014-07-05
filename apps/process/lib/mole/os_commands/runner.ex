defmodule Mole.OsCommands.Runner do
  def run(command) do
    Port.open({:spawn, command}, [:binary, :exit_status])
  end
end
