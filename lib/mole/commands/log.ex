defmodule Mole.Commands.Log do
  @behaviour Mole.Command

  def execute(args) do
    log_services services(args)
    loop_forever(args[:loop])
  end

  defp loop_forever(:no_loop), do: :no_loop
  defp loop_forever(_) do
    receive do
      _ -> loop_forever("")
    end
  end

  defp services(args), do: services(args, args[:service])
  defp services(args, nil), do: args
  defp services(args, one_service) do
    args
    |> Map.delete(:service)
    |> Map.put(:services, one_service)
  end

  defp log_services(args) do
    log_services(args, String.split(args[:services], ","))
  end

  defp log_services(_args, []), do: :done
  defp log_services(args, [service|tail]) do
    args
    |> Map.put(:service, service)
    |> Map.delete(:services)
    |> Map.delete(:loop)
    |> Mole.ServiceLogger.log_service

    log_services(args, tail)
  end
end
