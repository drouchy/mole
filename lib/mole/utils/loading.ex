defmodule Mole.Loading do
  @clear_line "\33[2K\r"
  @refresh_interval 200

  def load_for(message, duration) do
    pid = spawn_link fn -> loading(message, 0) end
    receive do
      _ -> :done
    after duration -> :done
    end
    send pid, "It's over"
    IO.puts "#{@clear_line}#{message} done."
    :done
  end

  defp loading(message, index) do
    IO.write @clear_line
    IO.write "#{message} [#{marker(index)}]"
    receive do
      _ -> :ok
    after @refresh_interval -> loading(message, index + 1)
    end
  end

  defp marker(i) do
    case rem(i,4) do
      0 -> "-"
      1 -> "\\"
      2 -> "|"
      3 -> "/"
    end
  end
end
