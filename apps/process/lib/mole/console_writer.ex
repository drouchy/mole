defmodule Mole.ConsoleWriter do
  def write(data) do
    IO.puts data
  end

  def write(prefix, data) do
    prefix_text = Mole.ANSI.colorize(prefix[:text], prefix[:color])
    write("#{prefix_text} - #{data}")
  end
end