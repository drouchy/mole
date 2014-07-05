defmodule ConsoleWriterWorkerTest do
  use ExUnit.Case
  import Mock

  import Mole.Workers.ConsoleWorker

  # init/2
  test "returns ok" do
    { :ok, nil } = init
  end

  # handle_cast/2 - simple write
  test_with_mock "returns a valid OTP tuple", Mole.ConsoleWriter, nil_mock do
    state = 'state'

    {:noreply, state} = handle_cast({ :write, "data to write" }, state)
  end

  test_with_mock "writes to the console the data", Mole.ConsoleWriter, nil_mock do
    state = 'state'

    {:noreply, state} = handle_cast({ :write, "data to write" }, state)

    assert called Mole.ConsoleWriter.write "data to write"
  end

  # handle_cast/2 - write with prefix
  test_with_mock "handle cast with prefix returns a valid OTP tuple", Mole.ConsoleWriter, nil_mock_prefix do
    state = 'state'

    {:noreply, state} = handle_cast({ :write, prefix, "data to write" }, state)
  end

  test_with_mock "handle cast with prefix writes to the console the data", Mole.ConsoleWriter, nil_mock_prefix do
    state = 'state'

    {:noreply, state} = handle_cast({ :write, prefix, "data to write" }, state)

    assert called Mole.ConsoleWriter.write prefix, "data to write"
  end

  defp nil_mock, do: [write: fn(_) -> end]
  defp nil_mock_prefix, do: [write: fn(_, _) -> end]

  defp prefix, do: 'prefix'
end