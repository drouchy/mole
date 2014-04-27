defmodule Mole.ANSI do
  def color(index) do
    elem(colors, rem(index, 6))
  end

  def colorize(text, color) do
    "#{ansi_color(color)}#{text}#{IO.ANSI.reset}"
  end

  defp ansi_color(color), do: color = apply(IO.ANSI, binary_to_atom(color), [])
  defp colors,            do: {"blue", "red", "green", "yellow", "magenta", "cyan"}
end