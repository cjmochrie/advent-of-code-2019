defmodule Day4 do
  def solve_1([first, second]) do
    start = parse_input(first)
    finish = parse_input(second) |> back_to_int
    IO.inspect start
    IO.inspect finish
    count_valid(start, finish)
  end

  def count_valid(password, maximum, valid \\ 0) do
    next_incrementing = valid_or_increase(password)
    cond do
      back_to_int(next_incrementing) > maximum -> valid
      adjacent?(next_incrementing) -> count_valid(plus_one(next_incrementing), maximum, valid + 1)
      true -> count_valid(plus_one(next_incrementing), maximum, valid)
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



  def adjacent?([first, second | rest]) do
    cond do
      first == second -> true
      true -> adjacent?([second | rest])
    end
  end

  def adjacent?([first]) do
    false
  end

  def parse_input(input) do
    String.graphemes(input)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(fn(n) -> elem(n, 0) end)
  end

  def back_to_int(int_list) do
    Enum.reverse(int_list)
    |> Enum.with_index
    |> Enum.map(fn({ val, index }) -> val * :math.pow(10,index) end)
    |> Enum.sum
    |> Kernel.trunc
  end

  def plus_one(int_list) do
    back_to_int(int_list) + 1 |> to_int_list
  end

  def to_int_list(num) do
    to_string(num) |> parse_input
  end
end


#123441
#123445
#
#123111
#123300
#123301
#123302
#123303
#123304
#123305
#123306
#123307
#123308
#123309
#123333
#
#123456
#123466
#
#123
#133
#144
#155
#166
#177
#188
#199
#220
#222
#223
#

























