defmodule SearchSupervisor do
  use ExUnit.Case
  use Webtest.Case

  test "it starts the config worker" do
    assert Process.whereis(:mole_config) != nil
  end

  test "it restarts the config worker when it crashes" do
    pid = Process.whereis(:mole_config)

    Process.exit pid, :to_test

    with_retries 5, 10 do
      new_pid = Process.whereis(:mole_config)
      assert new_pid != nil
      assert new_pid != pid
    end
  end
end