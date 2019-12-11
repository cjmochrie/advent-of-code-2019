defmodule Intcode do
  @position 0
  @immediate 1
  @terminate 99
  @add 1
  @mult 2
  @input 3
  @output 4
  @jmp_true 5
  @jmp_false 6
  @less_than 7
  @eql 8

  defmodule Computer do
    defstruct program: nil, position: 0, caller_id: nil
  end


  def execute(computer) do
    instruction = get(computer)
                  |> Utils.int_to_int_list
                  |> parse_code
    case instruction do
      { @terminate,_ } -> { :ok, computer }
      _ -> process_opcode(instruction, computer)
           |> execute
    end
  end

  def process_opcode({ @add, [mode_a, mode_b | _] }, computer) do
    [a, b, c] = slice(computer, 1, 3)
    a_value = param_value(mode_a, a, computer)
    b_value = param_value(mode_b, b, computer)
    computer = update(computer, c, a_value + b_value)
    %Computer{ computer | position: computer.position + 4 }
  end

  def process_opcode({ @mult, [mode_a, mode_b | _] }, computer) do
    [a, b, c] = slice(computer, 1, 3)
    a_value = param_value(mode_a, a, computer)
    b_value = param_value(mode_b, b, computer)
    computer = update(computer, c, a_value * b_value)
    %Computer{ computer | position: computer.position + 4 }
  end

  def process_opcode({ @input, _ }, computer) do
    address = get(%Computer{ computer | position: computer.position + 1 })
    %{ :caller_id => caller_id } = computer
    receive do
      { :input, value, ^caller_id } ->
        IO.puts "RECEIVING! #{value}"
        { value, _ } = Integer.parse(value)
        %Computer{ computer |
          program: update(computer, address, value).program,
          position: computer.position + 2 }
    after
      100 -> IO.puts "NEVER RECEIVED"
    end
  end

  def process_opcode({ @output, [mode | _] }, computer) do
    address = get(%Computer{ computer | position: computer.position + 1 })
    output = param_value(mode, address, computer)
    send(computer.caller_id, { :done, output })
    %Computer{ computer | position: computer.position + 2 }
  end

  def process_opcode({ @jmp_true, [mode_a, mode_b | _] }, computer) do
    [a, b] = slice(computer, 1, 2)
    if param_value(mode_a, a, computer) != 0 do
      %Computer{ computer | position: param_value(mode_b, b, computer) }
    else
      %Computer{ computer | position: computer.position + 3 }
    end
  end

  def process_opcode({ @jmp_false, [mode_a, mode_b | _] }, computer) do
    [a, b] = slice(computer, 1, 2)
    if param_value(mode_a, a, computer) == 0 do
      %Computer{ computer | position: param_value(mode_b, b, computer) }
    else
      %Computer{ computer | position: computer.position + 3 }
    end
  end

  def process_opcode({ @less_than, [mode_a, mode_b | _] }, computer) do
    [a, b, c] = slice(computer, 1, 3)
    a_value = param_value(mode_a, a, computer)
    b_value = param_value(mode_b, b, computer)

    %{ :program => program } = if a_value < b_value do
      update(computer, c, 1)
    else
      update(computer, c, 0)
    end
    %Computer{ computer | program: program, position: computer.position + 4 }
  end

  def process_opcode({ @eql, [mode_a, mode_b | _] }, computer) do
    [a, b, c] = slice(computer, 1, 3)
    a_value = param_value(mode_a, a, computer)
    b_value = param_value(mode_b, b, computer)

    %{ :program => program } = if a_value == b_value do
      update(computer, c, 1)
    else
      update(computer, c, 0)
    end
    %Computer{ computer | program: program, position: computer.position + 4 }
  end

  def param_value(@position, param, computer) do
    get(%Computer{ computer | position: param })
  end
  def param_value(@immediate, param, _) do
    param
  end

  def get(computer) do
    { _, value } = Enum.fetch(computer.program, computer.position)
    value
  end

  def slice(computer, offset, size) do
     Enum.slice(computer.program, computer.position + offset, size)
  end

  def update(computer, position, value) do
    %Computer{ computer | program: List.replace_at(computer.program, position, value) }
  end


  def parse_code([_, b, c, d, e]) do
    { d * 10 + e, [c, b, 0] }
  end
  def parse_code([b, c, d, e]) do
    { d * 10 + e, [c, b, 0] }
  end
  def parse_code([c, d, e]) do
    {  d * 10 + e, [c, 0, 0] }
  end
  def parse_code([d, e]) do
    { d * 10 + e, [0, 0, 0] }
  end
  def parse_code([e]) do
    { e, [0, 0, 0] }
  end
end