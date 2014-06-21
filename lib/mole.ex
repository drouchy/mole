defmodule Mole do
  use Application

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    start_lager()

    Mole.Supervisors.MainSupervisor.start_link
  end

  @lager_level Mole.Mixfile.project[:lager_level]

  defp start_lager do

    :application.set_env(:lager, :handlers, [lager_console_backend:
        [@lager_level, { :lager_default_formatter, [:time, ' [', :severity, '] ', :message, '\n']}]
    ], persistent: true)
    :application.set_env(:lager, :crash_log, :undefined, persistent: true)

    :application.ensure_all_started(:exlager)
  end

  def config, do: :gen_server.call(:mole_config, :config)
end
