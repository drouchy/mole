defmodule Mole.Supervisors.MainSupervisor do
  use Supervisor

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(Mole.Workers.ConsoleWorker,  []),
      worker(Mole.Workers.LoggerWorker,   []),
      worker(Mole.Workers.GateKeeper,     []),
      worker(Mole.Workers.SshConnectionWorker,     []),
      worker(Mole.Workers.ConfigWorker,   [ Mole.Config.config_file ])
    ]

    # See http://elixir-lang.org/docs/stable/Supervisor.Behaviour.html
    # for other strategies and supported options
    supervise(children, strategy: :one_for_one)
  end
end
