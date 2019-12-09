defmodule Day4 do
  def solve_1([first, second]) do
    start = Utils.string_to_int_list(first)
    finish = Utils.string_to_int_list(second) |> back_to_int
    count_valid(start, finish, &adjacent?/1)
  end

  def solve_2([first, second]) do
    start = Utils.string_to_int_list(first)
    finish = Utils.string_to_int_list(second) |> back_to_int
    count_valid(start, finish, &has_twin?/2)
  end

  def count_valid(password, maximum, validator, valid \\ 0) do
    next_incrementing = valid_or_increase(password)
    cond do
      back_to_int(next_incrementing) > maximum -> valid
      validator.(next_incrementing, nil) -> count_valid(plus_one(next_incrementing), maximum, validator, valid + 1)
      true -> count_valid(plus_one(next_incrementing), maximum, validator, valid)
    end
  end

  def valid_or_increase([first, second | rest]) do
    cond do
      first <= second -> [first | valid_or_increase([second | rest])]
      true -> List.duplicate(first, 2 + length(rest))
    end
  end

  def valid_or_increase([first]) do
    [first]
  end

  def has_twin?([first, second, third | rest], last) do
    cond do
      last == nil and first == second and second != third -> true
      last != first and first == second and second != third -> true
      true -> has_twin?([second, third | rest ], first)
    end
  end

  def has_twin?([first, second], last) do
    last != first and first == second
  end

  def adjacent?([first, second | rest]) do
    cond do
      first == second -> true
      true -> adjacent?([second | rest])
    end
  end

  def adjacent?([first]) do
    false
  end

  def back_to_int(int_list) do
    Enum.reverse(int_list)
    |> Enum.with_index
    |> Enum.map(fn({ val, index }) -> val * :math.pow(10,index) end)
    |> Enum.sum
    |> Kernel.trunc
  end

  def plus_one(int_list) do
    back_to_int(int_list) + 1 |> Utils.int_to_int_list
  end
end













