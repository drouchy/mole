defmodule Mole.Cli do
  def main(_args) do
    execute_command("environments")
  end

  defp execute_command("environments"), do: Mole.Commands.Environments.execute([])
end