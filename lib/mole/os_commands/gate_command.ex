defmodule Mole.OsCommands.GateCommand do
  def open_gate_command(details) do
    "ssh #{local_user(details)}#{details[:gateway]} #{identity(details)}-L #{details[:port]}:#{details[:host]}:22 -N"
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

end