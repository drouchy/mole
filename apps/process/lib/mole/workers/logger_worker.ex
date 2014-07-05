defmodule Mole.Workers.LoggerWorker do
  use GenServer

  @lagger_formatter [:time, ' [', :severity, '] ', :message, '\n']
  @lager_level Mole.Process.Mixfile.project[:lager_level]

  def start_link() do
    :gen_server.start_link({:local, :application_logger}, __MODULE__, [], [])
  end

  def init(_) do
    configure_lager
    { :ok , nil }
  end

  def handle_cast(_msg, _state) do
  end

  def handle_info(_msg, _state) do
  end

  def terminate(_reason, _state) do
  end

  def code_change(_old_vsn, _state, _extra) do
  end

  defp configure_lager do
    :application.set_env(:lager, :handlers, [
      lager_console_backend: [@lager_level, { :lager_default_formatter, [:time, ' [', :severity, '] ', :message, '\n']}],
      lager_file_backend:    [{:file, "#{home}/.mole/application.log"}, {:level, :debug}]
      ], persistent: true)
    :application.set_env(:lager, :crash_log, "#{home}/.mole/crash.log", persistent: true)

    :application.ensure_all_started(:exlager)
  end

  defp home, do: System.get_env["HOME"]
end
