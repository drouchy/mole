defmodule Mole.OsCommands.GateCommand do
  def open_gate_command(details) do
    "ssh #{ssh_options} #{local_user(details)}#{details[:gateway]} #{identity(details)}-L #{details[:port]}:#{details[:host]}:22 -t 2>/dev/null"
  end

  defp identity(details) do
    identity_option(details[:user_dir])
  end

  defp identity_option(nil), do: nil
  defp identity_option(user_dir), do: "-i #{user_dir}/id_rsa "

  defp local_user(details) do
    local_user_details(details[:user])
  end

  defp local_user_details(nil), do: nil
  defp local_user_details(username), do: "#{username}@"

  defp ssh_options, do: "-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
end