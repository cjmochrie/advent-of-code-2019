defmodule Day5 do
  def solve_1(input) do
    Enum.map(input, &Integer.parse/1)
    |> Enum.map(fn({token, _}) -> token end)
    |> Intcode.execute(0)
    |> List.first
  end
end