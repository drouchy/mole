defmodule ConfigTest do
  use ExUnit.Case

  import Mole.Config

  teardown _context do
    System.put_env("MOLE_CONFIG_FILE", "")
    :ok
  end

  # load/1
  test "loads a config file" do
    assert regular_config["global"] == [{"user", "drouchy"}, {"ssh_dir", "/var/tmp/mole_ssh"}]
  end

  # load
  test "loads the default config file" do
    System.put_env("MOLE_CONFIG_FILE", regular_file)

    assert load["global"] == [{"user", "drouchy"}, {"ssh_dir", "/var/tmp/mole_ssh"}]
  end

  # config_file
  test "by default gives the .mole/config.json in the home directory" do
    file_name = config_file

    assert file_name == "#{System.get_env("HOME")}/.mole/config.json"
  end

  test "by default gives the .mole/config.json in the home directory if the env is empty" do
    System.put_env("MOLE_CONFIG_FILE", "")

    file_name = config_file

    assert file_name == "#{System.get_env("HOME")}/.mole/config.json"
  end

  test "gives the config file set via env variable" do
    System.put_env("MOLE_CONFIG_FILE", "/var/tmp/config")

    file_name = config_file

    assert file_name == "/var/tmp/config"
  end

  # environments/1
  test "gives the available environments" do
    environments = environments(regular_config)

    assert names(environments) == ["staging", "production"]
  end

  # environment/2
  test "gives the environment" do
    environment = environment(regular_config, "staging")

    assert environment["name"] == "staging"
  end

  # services/2
  test "gives the services on the environment" do
    services = services(regular_config, "staging")

    assert names(services) == ["log_service", "db"]
  end

  # service/3
  test "gives a specific service on a specific environment" do
    service = service(regular_config, "staging", "db")

    assert service == [{"name", "db"}, {"hosts", ["db1"]}]
  end

  defp regular_file,   do: "test/fixtures/config/regular.json"
  defp regular_config, do: load regular_file

  defp names(enum) do
    Enum.map enum, fn(e) -> e["name"] end
  end
end