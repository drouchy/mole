defmodule CliTest do
  use ExUnit.Case
  import Mock

  test_with_mock "launch the environments command", Mole.Commands.Environments, [execute: fn(_)->end] do
    args = ["environments"]

    Mole.Cli.main(args)

    assert called Mole.Commands.Environments.execute(%{})
  end

  test_with_mock "launch the log command", Mole.Commands.Log, [execute: fn(_)->end] do
    args = ["log", "-e", "production", "-s", "test_service"]

    Mole.Cli.main(args)

    assert called Mole.Commands.Log.execute(%{command: "log", environment: "production", service: "test_service"})
  end
end