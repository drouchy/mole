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

  test "parses the log command with the services" do
    args = ["log", "--environment", "production", "--services", "service_1,service_2"]

    assert parse(args) == %{command: "log", services: "service_1,service_2", environment: "production"}
  end

  test "parses the log command with the services alias" do
    args = ["log", "--environment", "production", "-S", "service_1,service_2"]

    assert parse(args) == %{command: "log", services: "service_1,service_2", environment: "production"}
  end

  test "the command is :none when the args does not contain any command" do
    args = ["--environment", "production", "-s", "service_1"]

    assert parse(args) == %{command: :none, service: "service_1", environment: "production"}
  end

  test "the command is :none when the args are empty" do
    assert parse([]) == %{command: :none}
  end

end
