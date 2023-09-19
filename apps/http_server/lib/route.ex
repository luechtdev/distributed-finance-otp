defmodule Route do

  def split(route), do: String.split(route, "/") |> Enum.to_list |> List.to_tuple

  @type fragment :: {:static, String.t()} | {:dynamic, atom()}
  @type t :: [fragment]

  @doc """

    To make the route definitions dynamic and still readable.
    I decided to use a sigil instead of an encoded string.
    The Route can contain dynamic identifiers using the :id syntax.

    Elixir automatically calls the `sigil_p/2` function when the ~p
    sigil is used.

    Examples:
    - ~p</api/get_user/:user_id> will describe a static route with a dynamic user_id
    - ~p</:first/...> will describe any route
  """
  defmacro sigil_p(string, []) do
    for part <- String.split string, "/" do
      if dynamic? part do
        {:dynamic, String.to_atom part}
      else
        {:static, part}
      end
    end
  end

  defp dynamic?(part),  do: Regex.run(~r/:(\w+)/, part, capture: :all_but_first)
  # defp wildcard?(part), do: Regex.run(~r/\.{3}/,  part)

  defmacro defroute(path, impl) do
    arguments = for p <- path do
      case p do
        {:static, x}  -> x
        {:dynamic, x} -> Macro.var x, Elixir
      end
    end

    mapping = path
    |> Enum.filter(fn p -> elem(p, 0) === :dynamic end)
    |> Enum.map(&elem(&1,1))
    |> Enum.map(fn a -> {a, Macro.var(a, Elixir)} end)
    |> then(&{:%{}, [], &1})

    quote do
      def handle_route(unquote(arguments), req, res) do
        req[path_args] = unquote(mapping)
        unquote(impl).(req, res)
      end
    end
  end

end
