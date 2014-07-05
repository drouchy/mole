defmodule Mole.OptionParser do

  def parse(args) do
    { arguments, command, _unparsed} = OptionParser.parse(args, aliases: aliases)
    convert_command_args(command, arguments)
  end

  defp argument_to_map([], map), do: map
  defp argument_to_map([{name, value}|rest], map) do
    new_map = Map.put(map, name, value)
    argument_to_map(rest, new_map)
  end

  defp aliases, do: [e: :environment, s: :service, S: :services]

  defp convert_command_args([], arguments), do:  convert_command_args([:none], arguments)
  defp convert_command_args([command], arguments) do
    command_map = argument_to_map(arguments, %{})
    Map.put(command_map, :command, command)
  end
end
