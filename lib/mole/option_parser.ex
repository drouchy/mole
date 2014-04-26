defmodule Mole.OptionParser do

  def parse(args) do
    { arguments, [command], _unparsed} = OptionParser.parse(args, aliases: aliases)
    command_map = argument_to_map(arguments, %{})
    Map.put(command_map, :command, command)
  end

  defp argument_to_map([], map), do: map
  defp argument_to_map([{name, value}|rest], map) do
    new_map = Map.put(map, name, value)
    argument_to_map(rest, new_map)
  end

  defp aliases, do: [s: :service, e: :environment]
end