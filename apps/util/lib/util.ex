defmodule Util do

  defmacro a ~> b do
    quote do
      unquote(a) |> then(&(unquote(b)))
    end
  end

end
