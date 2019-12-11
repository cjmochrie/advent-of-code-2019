defmodule Utils do
  def string_to_int_list(input) do
    String.graphemes(input)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(fn(n) -> elem(n, 0) end)
  end

  def int_to_int_list(num) do
    to_string(num) |> string_to_int_list
  end


  #http://www.petecorey.com/blog/2018/11/12/permutations-with-and-without-repetition-in-elixir/
  def permutations([], _), do: [[]]
  def permutations(_, 0), do: [[]]
  def permutations(elements, n) do
     for head <- elements, tail <- permutations(elements -- [head], n - 1), do: [head | tail]
  end
end
