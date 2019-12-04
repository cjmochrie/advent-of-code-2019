defmodule Day2 do
  def solve_1(input) do
    Enum.map(input, &Integer.parse/1)
    |> Enum.map(fn({token, _}) -> token end)
    |> execute(0)
    |> List.first
  end

  def solve_2(input) do
    [pointer, _, _ | program] = Enum.map(input, &Integer.parse/1)
                                |> Enum.map(fn({token, _}) -> token end)
    { noun, verb } = find_inputs(19690720, [pointer, 0, 0 | program])
    "noun: #{noun} verb: #{verb}"
  end

  def find_inputs(desired, [pointer, noun, verb | program]) do
    cond do
      verb > 99 -> find_inputs(desired, [pointer, noun + 1, 0 | program])
      noun > 99 -> "WELP"
      execute([pointer, noun, verb | program], 0)
      |> List.first == desired -> { noun, verb }
      true -> find_inputs(desired, [pointer, noun, verb + 1 | program])
    end
  end

  def execute(program, position) do
    [code, a, b, output] = Enum.slice(program, position, 4)
    case code do
      99 -> program
      1 -> List.replace_at(
             program,
             output,
             get(program, a) + get(program, b)
           )
           |> execute(position + 4)
      2 -> List.replace_at(
             program,
             output,
             get(program, a) * get(program, b)
           )
           |> execute(position + 4)
    end
  end

  def get(list, position) do
    {_, value} = Enum.fetch(list, position)
    value
  end
end