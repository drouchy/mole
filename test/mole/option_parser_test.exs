defmodule OptionParserTest do
  use ExUnit.Case

  import Mole.OptionParser

  # parse/1
  test "returns the environments command" do
    %{command: "environments"} = parse ["environments"]
  end

  test "parses the log command" do
    args = ["log", "--environment", "production", "--service", "service_1"]

    assert parse(args) == %{command: "log", service: "service_1", environment: "production"}
  end

  test "parses the log command with the services aliases" do
    args = ["log", "--environment", "production", "-s", "service_1"]

    assert parse(args) == %{command: "log", service: "service_1", environment: "production"}
  end

  test "parses the log command with the environment aliases" do
    args = ["log", "-e", "production", "--service", "service_1"]
    assert parse(args) == %{command: "log", service: "service_1", environment: "production"}
  end
end
