defmodule Mole.Cli do
  def main(args) do
    parsed_args = Mole.OptionParser.parse(args)
    execute_command(parsed_args[:command], parsed_args)
  end

  defp execute_command("environments", _args), do: Mole.Commands.Environments.execute(%{})
  defp execute_command("log", args),           do: Mole.Commands.Log.execute(args)
  defp execute_command(_, args),               do: IO.puts usage_text


  defp usage_text do
    """
      usage: mole command [<args>]

      Basic commands:
        environments   manage environments in the config file

      Remote command:
        log            tail the logs on the remote servers
    """
  end
end
