defmodule Mole.LabelGenerator do
  def generate_label_for(service, destination) do
    "#{service["name"]} - #{hostname(destination[:host])}"
  end

  defp hostname(full_host_name) do
    full_host_name
    |> String.split(".")
    |> List.first
  end
end
