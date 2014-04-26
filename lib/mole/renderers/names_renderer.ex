defmodule Mole.Renderers.NamesRenderer do
  def render([]),   do: "\n"
  def render(enum), do: render("", enum)

  defp render(rendered, []), do: rendered
  defp render(rendered, [elt|rest]) do
    render("#{rendered}  #{elt["name"]}\n", rest)
  end
end