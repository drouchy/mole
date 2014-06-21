defmodule Mole.Commands.Environments do
  @behaviour Mole.Command

  def execute(_args) do
    environments = :gen_server.call :mole_config, :environments
    IO.write Mole.Renderers.NamesRenderer.render(environments)
  end
end
