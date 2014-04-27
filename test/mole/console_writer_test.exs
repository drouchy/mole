defmodule ConsoleWriterTest do
  use ExUnit.Case
  import Mock

  # write/1
  test_with_mock "writes to the IO", IO, [puts: fn(_) -> end] do
    Mole.ConsoleWriter.write("test to write")

    assert called IO.puts "test to write"
  end

  # write/2
  test_with_mock "write with a colored prefix", IO, [puts: fn(_) -> end] do
    prefix = %{text: "the prefix", color: "blue"}

    Mole.ConsoleWriter.write(prefix, "test to write")

    assert called IO.puts "\e[34mthe prefix\e[0m - test to write"
  end
end