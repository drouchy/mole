defmodule EnvironmentsCommandTest do
  use ExUnit.Case
  import Mock

  import Mole.Commands.Environments

  setup _context do
    :reloaded = :gen_server.call(:mole_config, {:reload, "test/fixtures/config/regular.json"})
    :ok
  end

  # execute/1
 test_with_mock "gets all the environments from the config and display them", IO, [write: fn(_) -> end] do
    execute([])

    assert called IO.write("  staging\n  production\n")
  end
end