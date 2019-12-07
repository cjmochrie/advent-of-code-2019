defmodule Utils do
  def string_to_int_list(input) do
    String.graphemes(input)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(fn(n) -> elem(n, 0) end)
  end

  def int_to_int_list(num) do
    to_string(num) |> string_to_int_list
  end
end