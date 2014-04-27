defmodule Mole.Cli do
  def main(args) do
    parsed_args = Mole.OptionParser.parse(args)
    execute_command(parsed_args[:command], parsed_args)
  end

  defp execute_command("environments", _args), do: Mole.Commands.Environments.execute(%{})
  defp execute_command("log", args),           do: Mole.Commands.Log.execute(args)
end