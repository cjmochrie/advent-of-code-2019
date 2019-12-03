defmodule Solvers do
  def solve_1_1(input) do
    Enum.map(input, &Float.parse/1)
    |> Enum.map(fn({mass, _}) -> calculate_fuel(mass) end)
    |> Enum.sum
  end

  def solve_1_2(input) do
    Enum.map(input, &Float.parse/1)
    |> Enum.map(fn({mass, _}) -> calculate_recursive_fuel(mass) end)
    |> Enum.sum
  end

  def calculate_recursive_fuel(mass) do
    fuel_needed = calculate_fuel(mass)
    if fuel_needed <= 0 do
      0
    else
      fuel_needed + calculate_recursive_fuel(fuel_needed)
    end
  end

  def calculate_fuel(mass) do
    ((mass / 3.0) |> Float.floor) - 2
  end
end