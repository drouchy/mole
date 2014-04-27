defmodule AnsiTest do
  use ExUnit.Case

  import Mole.ANSI

  # {"blue", "red", "green", "yellow", "magenta", "cyan"}
  # color/1
  test "returns blue for index 0" do
    assert color(0) == "blue"
  end

  test "returns red for index 1" do
    assert color(1) == "red"
  end

  test "returns green for index 2" do
    assert color(2) == "green"
  end

  test "returns yellow for index 3" do
    assert color(3) == "yellow"
  end

  test "returns magenta for index 4" do
    assert color(4) == "magenta"
  end

  test "returns cyan for index 5" do
    assert color(5) == "cyan"
  end

  test "supports 'big' indexes" do
    assert color(9) == "yellow"
  end

  # colorize/2
  test "it surrounds the text with an ANSI color" do
    assert colorize("the text", "blue") == "\e[34mthe text\e[0m"
  end
end