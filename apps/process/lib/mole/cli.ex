defmodule Mole.Cli do
  def main(args) do
    parsed_args = Mole.OptionParser.parse(args)
    check_config
    execute_command(parsed_args[:command], parsed_args)
  end

  defp execute_command("environments", _args), do: Mole.Commands.Environments.execute(%{})
  defp execute_command("log", args),           do: Mole.Commands.Log.execute(args)
  defp execute_command(_, _),                  do: IO.puts usage_text

  defp usage_text do
    """
      usage: mole command [<args>]

      Basic commands:
        environments   manage environments in the config file

      Remote command:
        log            tail the logs on the remote servers
    """
  end

  defp check_config do
    case Mole.Config.load do
      {:error, :enoent  } -> IO.puts :stderr, "no config file found. Use 'mole config init' to create one"; System.halt(2)
      {:error, :invalid } -> IO.puts :stderr, "invalid config file"; System.halt(3)
      {:ok, _}           -> :ok
    end
  end
end
