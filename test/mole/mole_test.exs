defmodule MoleTest do
  use ExUnit.Case

  test "the truth" do
    assert 1 + 1 == 2
  end

  # config/0
  test "query the config worker" do
    config_file = "test/fixtures/config/regular.json"
    :gen_server.call :mole_config, {:reload, config_file}

    config = Mole.config

    assert config["global"]["user"] == "drouchy"
  end
end
