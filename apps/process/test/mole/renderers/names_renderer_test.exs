defmodule NamesRendererTest do
  use ExUnit.Case

  import Mole.Renderers.NamesRenderer

  # render/1
  test "generate an empty string for an empty list" do
    rendered = render([])

    assert rendered == "\n"
  end

  test "generate one line per entry, indexed by 2 spaces" do
    list = [%{"name" => "line 1"}, %{"name" => "line 2"}]

    rendered = render(list)

    assert rendered == "  line 1\n  line 2\n"
  end
end
