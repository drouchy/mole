defmodule Mole.Command.LogTest do
  use ExUnit.Case
  import Mock

  import Mole.Commands.Log

  test_with_mock "log one service", Mole.ServiceLogger,
  [log_service: fn(_) -> :ok end] do
    execute(%{loop: :no_loop, service: "service_1"})

    assert called Mole.ServiceLogger.log_service(%{service: "service_1"})
  end

  test_with_mock "log multiple services", Mole.ServiceLogger,
  [log_service: fn(_) -> :ok end] do
    execute(%{loop: :no_loop, services: "service_1,service_2"})

    assert called Mole.ServiceLogger.log_service(%{service: "service_1"})
    assert called Mole.ServiceLogger.log_service(%{service: "service_2"})
  end
end
