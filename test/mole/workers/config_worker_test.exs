defmodule ConfigWorkerTest do
  use ExUnit.Case
  import Mock

  import Mole.Workers.ConfigWorker

  setup _context do
    :reloaded = :gen_server.call(:mole_config, {:reload, "test/fixtures/config/regular.json"})
    :ok
  end

  # init/2
  test "returns ok" do
    { :ok, _ } = init(config_file)
  end

  test "returns the config" do
    { :ok, config } = init(config_file)

    assert config["global"] == [{"user", "drouchy"}, {"ssh_dir", "/var/tmp/mole_ssh"}]
  end

  # handle_call/3 { :environments }
  test_with_mock "reads the environments from the config", Mole.Config,
  [ environments: fn("CONFIG") -> environments end ] do
    { :reply, environments, "CONFIG" } = handle_call(:environments, self, "CONFIG")
  end

  # handle_call/3 { :service, environment_name, service_name }
  test_with_mock "find the service in the config file", Mole.Config,
  [ service: fn("CONFIG", "staging", "service_name") -> service end] do
    { :reply, s, "CONFIG"} = handle_call({:service, "staging", "service_name"}, self, "CONFIG")

    assert s == service
  end

  # handle_call/3 { :reload, file_name }
  test "reloads the configuration" do
    { :reply, :reloaded, config } = handle_call({:reload, alternative_file}, self, "CONFIG")

    [first_env|_] = config["environments"]

    assert first_env["name"] == "alternative_1"
  end

  def config_file,       do: "test/fixtures/config/regular.json"
  def alternative_file,  do: "test/fixtures/config/alternative.json"
  def environments,      do: ["env1", "env2"]
  def service,           do: {name: "service_1"}
end