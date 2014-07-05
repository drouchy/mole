defmodule Mole.Config do
  use Jazz

  def load(), do: load config_file
  def load(file_name) do
    File.read(file_name)
    |> decode_content
  end

  def config_file do
    System.get_env("MOLE_CONFIG_FILE") |> config_file
  end

  def version(config) do
    config["version"]
  end

  def environments(config) do
    config["environments"]
  end

  def environment(config, environment_name) do
    Enum.find(config["environments"], fn (env) -> env["name"] == environment_name end)
  end

  def services(config, environment_name) do
    environment(config, environment_name)["services"]
  end

  def service(config, environment_name, service_name) do
    Enum.find(services(config, environment_name), fn(s) -> s["name"] == service_name end)
  end

  defp config_file(nil),      do: Path.expand("~/.mole/config.json")
  defp config_file(""),       do: Path.expand("~/.mole/config.json")
  defp config_file(filename), do: filename

  defp decode_content({:error, :enoent}), do:  {:error, :enoent}
  defp decode_content({ :ok, content})    do
    case JSON.decode content do
      {:ok, json}           -> {:ok, json}
      {:error, :invalid, _} -> {:error, :invalid}
    end
  end
end
