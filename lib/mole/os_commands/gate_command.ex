defmodule Mole.OsCommands.GateCommand do
  def open_gate_command(options, from, to) do
    "ssh #{local_user(options)}#{from} #{identity(options)}-L #{options[:port]}:#{to}:22 -N"
  end

  defp identity(options) do
    identity_option(options[:user_dir])
  end

  defp identity_option(nil), do: nil
  defp identity_option(user_dir), do: "-i #{user_dir}/id_rsa "

  defp local_user(options) do
    local_user_options(options[:user])
  end

  defp local_user_options(nil), do: nil
  defp local_user_options(username), do: "#{username}@"

end