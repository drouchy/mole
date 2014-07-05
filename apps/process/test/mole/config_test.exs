defmodule ConfigTest do
  use ExUnit.Case

  alias Mole.Config

  setup do
    on_exit fn ->
      System.put_env("MOLE_CONFIG_FILE", "")
      :ok
    end
  end

  # load/1
  test "loads a config file" do
    assert regular_config["global"] == %{ "user" => "drouchy", "ssh_dir" => "/var/tmp/mole_ssh" }
  end

  test "errors when the file does no exists" do
    { :error, :enoent } = Config.load "/does/not/exist"
  end

  test "errors when the file is no valid json" do
    { :error, :invalid } = Config.load malformed_file
  end

  # load
  test "loads the default config file" do
    System.put_env("MOLE_CONFIG_FILE", regular_file)

    { :ok, config } = Config.load

    assert config["global"] == %{ "user" => "drouchy", "ssh_dir" => "/var/tmp/mole_ssh" }
  end

  # config_file
  test "by default gives the .mole/config.json in the home directory" do
    file_name = Config.config_file

    assert file_name == "#{System.get_env("HOME")}/.mole/config.json"
  end

  test "by default gives the .mole/config.json in the home directory if the env is empty" do
    System.put_env("MOLE_CONFIG_FILE", "")

    file_name = Config.config_file

    assert file_name == "#{System.get_env("HOME")}/.mole/config.json"
  end

  test "gives the config file set via env variable" do
    System.put_env("MOLE_CONFIG_FILE", "/var/tmp/config")

    file_name = Config.config_file

    assert file_name == "/var/tmp/config"
  end

  # version/0
  test "gives the version of the config file" do
    assert Config.version(regular_config) == 1
  end

  # environments/1
  test "gives the available environments" do
    environments = Config.environments(regular_config)

    assert names(environments) == ["staging", "production"]
  end

  # environment/2
  test "gives the environment" do
    environment = Config.environment(regular_config, "staging")

    assert environment["name"] == "staging"
  end

  # services/2
  test "gives the services on the environment" do
    services = Config.services(regular_config, "staging")

    assert names(services) == ["log_service", "db"]
  end

  # service/3
  test "gives a specific service on a specific environment" do
    service = Config.service(regular_config, "staging", "db")

    assert service == %{ "name" => "db", "hosts" => ["db1"] }
  end

  defp regular_file,   do: "test/fixtures/config/regular.json"
  defp malformed_file, do: "test/fixtures/config/malformed.json"

  defp regular_config  do
    { :ok, config } = Config.load regular_file
    config
  end

  defp names(enum) do
    Enum.map enum, fn(e) -> e["name"] end
  end
end
