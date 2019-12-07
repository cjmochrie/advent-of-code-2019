defmodule Day5 do
  @position 0
  @immediate 1

  def solve_1(input) do
    Enum.map(input, &Integer.parse/1)
    |> Enum.map(fn({token, _}) -> token end)
    |> execute(0)
    |> List.first
  end

  def execute(program, position) do
    code = get(program, position)
#    IO.puts "code: #{code}"
#    IO.inspect program
    case Utils.int_to_int_list(code) |> parse_code do
      { _, _, _, 99 } -> program
      { mode_c, mode_b, mode_a, 1 } ->
        process_opcode_1(
          mode_c,
          mode_b,
          mode_a,
          Enum.slice(program, position + 1, 3),
          program
        )
        |> execute(position + 4)
      { mode_c, mode_b, mode_a, 2 } ->
        process_opcode_2(
          mode_c,
          mode_b,
          mode_a,
          Enum.slice(program, position + 1, 3),
          program
        )
        |> execute(position + 4)
      { _, _, _, 3} -> process_opcode_3(
                         get(program, position + 1),
                         program
                       )
                       |> execute(position + 2)
      { _, _, mode, 4} -> process_opcode_4(
                            mode,
                            get(program, position + 1),
                            program
                          )
                          |> execute(position + 2)
    end
  end

  def parse_code([_, b, c, d, e]) do
    { 0, b, c, d * 10 + e }
  end
  def parse_code([b, c, d, e]) do
    { 0, b, c, d * 10 + e }
  end
  def parse_code([c, d, e]) do
    { 0, 0, c, d * 10 + e }
  end
  def parse_code([d, e]) do
    { 0, 0, 0, d * 10 + e }
  end
  def parse_code([e]) do
    { 0, 0, 0, e }
  end

  def process_opcode_1(_, mode_b, mode_a, [a, b, c], program) do
    a_value = param_value(mode_a, a, program)
    b_value = param_value(mode_b, b, program)

    List.replace_at(program, c, a_value + b_value)
  end

  def process_opcode_2(_, mode_b, mode_a, [a, b, c], program) do
#    IO.puts "processing opcode 2"
#    IO.puts "modes: #{mode_a}, #{mode_b}"
    a_value = param_value(mode_a, a, program)
    b_value = param_value(mode_b, b, program)
#    IO.puts "values: #{a_value}, #{b_value}"

    List.replace_at(program, c, a_value * b_value)
  end

  def process_opcode_3(address, program) do
    input= IO.gets "What is the input?"
    { value, _ } = Integer.parse(input)
    List.replace_at(program, address, value)
  end

  def process_opcode_4(mode, param, program) do
    IO.puts "Output: #{param_value(mode, param, program)}"
    program
  end

  def param_value(@position, param, program) do
    get(program, param)
  end
  def param_value(@immediate, param, _) do
    param
  end

  def get(list, position) do
    {_, value} = Enum.fetch(list, position)
    value
  end
end