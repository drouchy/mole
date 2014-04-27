defmodule Mole.Commands.Log do
  @behaviour Mole.Command

  def execute(args) do
    IO.inspect args
  end
end