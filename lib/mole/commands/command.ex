defmodule Mole.Command do
  use Behaviour

  defcallback execute(args :: List) :: nil
end