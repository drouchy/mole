defmodule Mole.Cli do
  def main(args) do
    parsed_args = Mole.OptionParser.parse(args)
    execute_command(parsed_args[:command])
  end

  defp execute_command("environments"), do: Mole.Commands.Environments.execute([])
end