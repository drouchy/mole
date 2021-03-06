defmodule Mole do
  use Application

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Mole.Supervisors.MainSupervisor.start_link
  end

  def config, do: :gen_server.call(:mole_config, :config)
end
